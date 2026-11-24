package com.ionicframework.intune;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.widget.Toast;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.microsoft.identity.client.AuthenticationCallback;
import com.microsoft.identity.client.IAccount;
import com.microsoft.identity.client.IAuthenticationResult;
import com.microsoft.identity.client.ICurrentAccountResult;
import com.microsoft.identity.client.exception.MsalException;
import com.microsoft.identity.client.exception.MsalIntuneAppProtectionPolicyRequiredException;
import com.microsoft.identity.client.exception.MsalUserCancelException;
import com.microsoft.intune.mam.client.app.MAMComponents;
import com.microsoft.intune.mam.client.identity.MAMPolicyManager;
import com.microsoft.intune.mam.client.notification.MAMNotificationReceiver;
import com.microsoft.intune.mam.client.notification.MAMNotificationReceiverRegistry;
import com.microsoft.intune.mam.policy.AppPolicy;
import com.microsoft.intune.mam.policy.MAMEnrollmentManager;
import com.microsoft.intune.mam.policy.appconfig.MAMAppConfig;
import com.microsoft.intune.mam.policy.appconfig.MAMAppConfigManager;
import com.microsoft.intune.mam.policy.notification.MAMEnrollmentNotification;
import com.microsoft.intune.mam.policy.notification.MAMNotificationType;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import org.json.JSONException;
import org.json.JSONObject;

@CapacitorPlugin(name = "IntuneMAM")
public class IntunePlugin extends Plugin {

    private static final String SETTINGS_PATH = "com.outsystems.intunedemo";

    public static final String[] MSAL_SCOPES = { "https://graph.microsoft.com/User.Read" };

    AppAccount mUserAccount;

    MAMEnrollmentManager mEnrollmentManager;

    PluginCall mLastEnrollCall;

    // How long registerAndEnrollAccount waits for Intune's result before rejecting with TIMEOUT.
    private static final int ENROLLMENT_TIMEOUT_SECONDS = 60;

    // The registerAndEnrollAccount call waiting for Intune's result.
    private PluginCall mPendingEnrollCall;

    private final MAMNotificationReceiver mEnrollmentReceiver = (notification) -> {
        if (notification instanceof MAMEnrollmentNotification) {
            settleEnrollCall(((MAMEnrollmentNotification) notification).getEnrollmentResult());
        }
        return true;
    };

    @Override
    public void load() {
        super.load();
        mEnrollmentManager = MAMComponents.get(MAMEnrollmentManager.class);
        MAMComponents.get(MAMNotificationReceiverRegistry.class).registerReceiver(
            mEnrollmentReceiver,
            MAMNotificationType.MAM_ENROLLMENT_RESULT
        );

        final SharedPreferences prefs = getContext().getSharedPreferences(SETTINGS_PATH, Context.MODE_PRIVATE);
        mUserAccount = AppAccount.readFromSettings(prefs);
    }

    @Override
    protected void handleOnDestroy() {
        MAMComponents.get(MAMNotificationReceiverRegistry.class).unregisterReceiver(
            mEnrollmentReceiver,
            MAMNotificationType.MAM_ENROLLMENT_RESULT
        );
        super.handleOnDestroy();
    }

    private void _acquireToken(PluginCall call, boolean interactive) {
        mLastEnrollCall = call;

        String accountId = call.getString("accountId");

        boolean forcePrompt = call.getBoolean("forcePrompt", false);
        boolean forceRefresh = call.getBoolean("forceRefresh", false);

        String[] scopesArray = null;

        try {
            JSArray scopes = call.getArray("scopes");
            scopesArray = scopes.toList().toArray(new String[0]);
        } catch (Exception ex) {
            call.reject("Must provide scopes list", ex);
            return;
        }

        final String[] scopes = scopesArray;

        // initiate the MSAL authentication on a background thread
        Thread thread = new Thread(() -> {
            Logger.info("Starting " + (interactive ? "interactive" : "silent") + " auth");

            try {
                if (interactive) {
                    String loginHint = null;
                    if (mUserAccount != null && !forcePrompt) {
                        loginHint = mUserAccount.getAccountId();
                    }
                    MSALUtil.acquireToken(getActivity(), scopes, loginHint, forcePrompt, new AuthCallback());
                } else {
                    MSALUtil.acquireTokenSilent(getActivity(), accountId, scopes, new AuthCallback(), forceRefresh);
                }
            } catch (Exception e) {
                // Also catches MSAL's unchecked errors, like a malformed auth_config.json.
                Logger.error("Authentication exception occurred", e);
                showMessage("Authentication exception occurred - check logcat for more details.");
                mLastEnrollCall = null;
                call.reject("Authentication failed: " + e.getMessage(), e);
            }
        });
        thread.start();
    }

    @PluginMethod
    public void acquireToken(PluginCall call) {
        _acquireToken(call, true);
    }

    @PluginMethod
    public void acquireTokenSilent(PluginCall call) {
        _acquireToken(call, false);
    }

    @PluginMethod
    public void registerAndEnrollAccount(PluginCall call) {
        final AppAccount account = mUserAccount;
        if (account == null) {
            call.reject("No user account. Call acquireToken first");
            return;
        }

        synchronized (this) {
            if (mPendingEnrollCall != null) {
                mPendingEnrollCall.reject("Replaced by a newer registerAndEnrollAccount call");
            }
            mPendingEnrollCall = call;
        }
        mEnrollmentManager.registerAccountForMAM(account.getAccountId(), account.getAADID(), account.getTenantID(), account.getAuthority());
        // acquireToken already registers the account, and Intune reports each result once, so check the current status too.
        settleEnrollCall(mEnrollmentManager.getRegisteredAccountStatus(account.getAccountId(), account.getAADID()));

        new Handler(Looper.getMainLooper()).postDelayed(() -> {
            synchronized (this) {
                if (mPendingEnrollCall == call) {
                    call.reject("Intune didn't report an enrollment result within " + ENROLLMENT_TIMEOUT_SECONDS + " seconds", "TIMEOUT");
                    mPendingEnrollCall = null;
                }
            }
        }, ENROLLMENT_TIMEOUT_SECONDS * 1000L);
    }

    private synchronized void settleEnrollCall(MAMEnrollmentManager.Result result) {
        if (mPendingEnrollCall == null || result == null) {
            return;
        }
        switch (result) {
            case ENROLLMENT_SUCCEEDED:
                mPendingEnrollCall.resolve();
                break;
            case PENDING:
            case UNENROLLMENT_SUCCEEDED:
            case UNENROLLMENT_FAILED:
                // Not this enrollment's final result.
                return;
            default:
                mPendingEnrollCall.reject("Intune enrollment failed: " + result.name(), result.name());
        }
        mPendingEnrollCall = null;
    }

    @PluginMethod
    public void loginAndEnrollAccount(PluginCall call) {
        mLastEnrollCall = call;

        boolean forcePrompt = call.getBoolean("forcePrompt", false);

        // initiate the MSAL authentication on a background thread
        Thread thread = new Thread(() -> {
            Logger.info("Starting interactive auth");

            try {
                String loginHint = null;
                if (mUserAccount != null) {
                    loginHint = mUserAccount.getAccountId();
                }
                MSALUtil.acquireToken(getActivity(), MSAL_SCOPES, loginHint, forcePrompt, new AuthCallback());
            } catch (Exception e) {
                // Also catches MSAL's unchecked errors, like a malformed auth_config.json.
                Logger.error("Authentication exception occurred", e);
                showMessage("Authentication exception occurred - check logcat for more details.");
                mLastEnrollCall = null;
                call.reject("Authentication failed: " + e.getMessage(), e);
            }
        });
        thread.start();
    }

    @PluginMethod
    public void enrolledAccount(PluginCall call) {
        JSObject data = new JSObject();
        if (mUserAccount != null) {
            data.put("accountId", mUserAccount.getAccountId());
        } else {
            data.put("accountId", "");
        }
        call.resolve(data);
    }

    @PluginMethod
    public void deRegisterAndUnenrollAccount(PluginCall call) {
        // Initiate an MSAL sign out on a background thread.
        final AppAccount effectiveAccount = mUserAccount;
        if (effectiveAccount == null) {
            call.resolve();
            return;
        }

        Thread thread = new Thread(() -> {
            boolean didSignout = false;
            try {
                MSALUtil.signOutAccount(getContext(), effectiveAccount.getAADID());
                didSignout = true;
            } catch (MsalException | InterruptedException e) {
                call.reject("Unable to log user out", e);
                Logger.error("Failed to sign out user " + effectiveAccount.getAADID(), e);
            }

            mEnrollmentManager.unregisterAccountForMAM(effectiveAccount.getAccountId());

            final SharedPreferences prefs = getContext().getSharedPreferences(SETTINGS_PATH, Context.MODE_PRIVATE);
            AppAccount.clearFromSettings(prefs);

            mUserAccount = null;

            if (didSignout) {
                call.resolve();
            }
        });
        thread.start();
    }

    @PluginMethod
    public void logoutOfAccount(PluginCall call) {
        final AppAccount effectiveAccount = mUserAccount;

        if (effectiveAccount != null) {
            Thread thread = new Thread(() -> {
                try {
                    MSALUtil.signOutAccount(getContext(), effectiveAccount.getAADID());
                    call.resolve();
                } catch (MsalException | InterruptedException e) {
                    call.reject("Unable to log user out", e);
                    Logger.error("Failed to sign out user " + effectiveAccount.getAADID(), e);
                }
                mEnrollmentManager.unregisterAccountForMAM(effectiveAccount.getAccountId());
                mUserAccount = null;
            });
            thread.start();
        } else {
            call.resolve();
        }
    }

    @PluginMethod
    public void appConfig(PluginCall call) {
        String accountId = call.getString("accountId");

        if (accountId == null) {
            call.reject("No accountId provided");
            return;
        }

        MAMAppConfigManager configManager = MAMComponents.get(MAMAppConfigManager.class);
        MAMAppConfig appConfig = configManager.getAppConfig(accountId);

        JSObject data = new JSObject();
        data.put("fullData", new JSArray(appConfig.getFullData()));
        call.resolve(data);
    }

    @PluginMethod
    public void groupName(PluginCall call) {
        String accountId = call.getString("accountId");

        if (accountId == null) {
            call.reject("No accountId provided");
            return;
        }

        MAMAppConfigManager configManager = MAMComponents.get(MAMAppConfigManager.class);
        MAMAppConfig data = configManager.getAppConfig(accountId);

        String groupNameKey = "GroupName";

        String groupName;

        if (!data.hasConflict(groupNameKey)) {
            groupName = data.getStringForKey(groupNameKey, MAMAppConfig.StringQueryType.Any);
        } else {
            groupName = data.getStringForKey(groupNameKey, MAMAppConfig.StringQueryType.Max);
        }

        call.resolve(
            new JSObject() {
                {
                    put("value", groupName);
                }
            }
        );
    }

    @PluginMethod
    @SuppressWarnings("unused")
    public void getPolicy(PluginCall call) {
        AppPolicy policy = MAMPolicyManager.getPolicy(getActivity());

        JSObject data = new JSObject();
        data.put("contactSyncAllowed", policy.getIsContactSyncAllowed());
        data.put("pinRequired", policy.getIsPinRequired());
        data.put("managedBrowserRequired", policy.getIsManagedBrowserRequired());
        data.put("screenCaptureAllowed", policy.getIsScreenCaptureAllowed());
        call.resolve(data);
    }

    @PluginMethod
    public void sdkVersion(PluginCall call) {
        // The Intune SDK writes its version into the app manifest.
        PackageManager pm = getContext().getPackageManager();
        String packageName = getContext().getPackageName();
        try {
            ApplicationInfo info =
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU
                    ? pm.getApplicationInfo(packageName, PackageManager.ApplicationInfoFlags.of(PackageManager.GET_META_DATA))
                    : pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA);
            JSObject data = new JSObject();
            data.put("version", info.metaData.getString("com.microsoft.intune.mam.MAMSDKVersion"));
            call.resolve(data);
        } catch (PackageManager.NameNotFoundException e) {
            call.reject("Couldn't read the Intune SDK version", e);
        }
    }

    @PluginMethod
    public void displayDiagnosticConsole(PluginCall call) {
        MAMPolicyManager.showDiagnostics(getContext());
        call.resolve();
    }

    private void showMessage(final String message) {
        bridge.getActivity().runOnUiThread(() -> {
            Toast.makeText(getContext(), message, Toast.LENGTH_SHORT).show();
        });
    }

    private class AuthCallback implements AuthenticationCallback {

        @Override
        public void onError(final MsalException exc) {
            Logger.error("authentication failed", exc);

            if (mLastEnrollCall != null) {
                mLastEnrollCall.reject("Authentication error", exc);
                mLastEnrollCall = null;
            }

            if (exc instanceof MsalIntuneAppProtectionPolicyRequiredException) {
                MsalIntuneAppProtectionPolicyRequiredException appException = (MsalIntuneAppProtectionPolicyRequiredException) exc;

                // Note: An app that has enabled APP CA with Policy Assurance would need to pass these values to `remediateCompliance`.
                // For more information, see https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-android#app-ca-with-policy-assurance
                final String accountId = appException.getAccountUpn();
                final String aadid = appException.getAccountUserId();
                final String tenantId = appException.getTenantId();
                final String authorityURL = appException.getAuthorityUrl();

                // The user cannot be considered "signed in" at this point, so don't save it to the settings.
                mUserAccount = new AppAccount(accountId, aadid, tenantId, authorityURL);

                final String message = "Intune App Protection Policy required.";
                showMessage(message);

                Logger.info("MsalIntuneAppProtectionPolicyRequiredException received.");
                Logger.info(
                    String.format(
                        "Data from broker: Account ID: %s; AAD ID: %s; Tenant ID: %s; Authority: %s",
                        accountId,
                        aadid,
                        tenantId,
                        authorityURL
                    )
                );
            } else if (exc instanceof MsalUserCancelException) {
                showMessage("User cancelled sign-in request");
            } else {
                showMessage("Exception occurred - check logcat");
            }
        }

        @Override
        public void onSuccess(final IAuthenticationResult result) {
            IAccount account = result.getAccount();

            final String accountId = account.getId();
            final String aadId = account.getId();
            final String tenantId = account.getTenantId();
            final String authorityURL = account.getAuthority();
            final String token = result.getAccessToken();
            final String idToken = account.getIdToken();

            String message = "Authentication succeeded for user " + accountId;
            Logger.info(message);

            // Save the user account in the settings, since the user is now "signed in".
            mUserAccount = new AppAccount(accountId, aadId, tenantId, authorityURL);

            final SharedPreferences prefs = getContext().getSharedPreferences(SETTINGS_PATH, Context.MODE_PRIVATE);
            mUserAccount.saveToSettings(prefs);

            // Register the account for MAM.
            mEnrollmentManager.registerAccountForMAM(accountId, aadId, tenantId, authorityURL);

            if (mLastEnrollCall != null) {
                JSObject data = new JSObject();
                data.put("accountId", accountId);
                data.put("accessToken", token);
                data.put("idToken", idToken);
                data.put("accountIdentifier", accountId);
                mLastEnrollCall.resolve(data);
                mLastEnrollCall = null;
            }
        }

        @Override
        public void onCancel() {
            showMessage("User cancelled auth attempt");
            if (mLastEnrollCall != null) {
                mLastEnrollCall.reject("User cancelled auth attempt");
                mLastEnrollCall = null;
            }
        }
    }
}
