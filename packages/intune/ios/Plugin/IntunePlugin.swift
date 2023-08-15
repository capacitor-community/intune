import Foundation
import Capacitor
import IntuneMAMSwift
import MSAL

@objc(IntuneMAM)
public class IntuneMAM: CAPPlugin, IntuneMAMComplianceDelegate {
    weak var enrollmentDelegate: EnrollmentDelegateClass?
    weak var policyDelegate = PolicyDelegateClass()
    private var loginAndEnrollContinuation: CheckedContinuation<Any, Error>?

    private func resetDelegate() {
        IntuneMAMEnrollmentManager.instance().delegate = EnrollmentDelegateClass()
    }

    override public func load() {
        print("IntuneMAM Loading")
        self.resetDelegate()
        IntuneMAMPolicyManager.instance().delegate = policyDelegate
        // register for the IntuneMAMAppConfigDidChange notification
        IntuneMAMComplianceManager.instance().delegate = self

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIntuneMAMAppConfigDidChange),
                                               name: NSNotification.Name.IntuneMAMAppConfigDidChange,
                                               object: IntuneMAMAppConfigManager.instance())

        // register for the IntuneMAMPolicyDidChange notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIntuneMAMPolicyDidChange),
                                               name: NSNotification.Name.IntuneMAMPolicyDidChange,
                                               object: IntuneMAMPolicyManager.instance())

    }

    public func identity(_ identity: String, hasComplianceStatus status: IntuneMAMComplianceStatus, withErrorMessage errMsg: String, andErrorTitle errTitle: String) {
        switch status {
        case .compliant:
            // Handle successful compliance
            print("Compliant!")
        case .notCompliant, .networkFailure, .serviceFailure, .userCancelled:
            DispatchQueue.main.async {
                let alert = UIAlertController(title: errTitle, message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    exit(0)
                }))
                self.bridge?.viewController?.present(alert, animated: true, completion: nil)
            }
        case .interactionRequired:
            IntuneMAMComplianceManager.instance().remediateCompliance(forIdentity: identity, silent: false)
        default:
            print("Unknown compliance status value")
        }
    }

    @objc func onIntuneMAMAppConfigDidChange() {
        // Emit event
        print("AppConfig did change")
        notifyListeners("appConfigChange", data: nil)
    }

    @objc func onIntuneMAMPolicyDidChange() {
        print("Intune policy did change")
        notifyListeners("policyChange", data: nil)
    }

    func _acquireToken(_ call: CAPPluginCall, interactive: Bool) {

        // Used for refreshing a token
        let upn = call.getString("upn")
        if !interactive && upn == nil {
            call.reject("upn must be provided to refresh token")
            return
        }

        let forcePrompt = call.getBool("forcePrompt", false)
        let forceRefresh = call.getBool("forceRefresh", false)

        guard let scopes = call.getArray("scopes") as? [String] else {
            call.reject("scopes not provided")
            return
        }

        guard let intuneSettings = Bundle.main.object(forInfoDictionaryKey: "IntuneMAMSettings") as? [AnyHashable: AnyHashable] else {
            call.reject("IntuneMAMSettings must be set in Info.plist to use this method. See https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#configure-msal-settings-for-the-intune-app-sdk")
            return
        }

        guard let clientId = intuneSettings["ADALClientId"] as? String else {
            call.reject("ADALClientId must be specified in IntuneMAMSettings in Info.plist")
            return
        }

        let redirectUri = intuneSettings["ADALRedirectUri"] as? String
        let authorityUriValue = intuneSettings["ADALAuthority"] as? String

        var authority: MSALAuthority?
        if let authorityUri = authorityUriValue {
            if let u = URL(string: authorityUri) {
                authority = try? MSALAuthority(url: u)
            }
        }

        DispatchQueue.main.async { [weak self] in
            do {
                var config: MSALPublicClientApplicationConfig?

                if redirectUri != nil {
                    config = MSALPublicClientApplicationConfig(clientId: clientId, redirectUri: redirectUri, authority: authority)
                } else {
                    config = MSALPublicClientApplicationConfig(clientId: clientId)
                }

                config?.clientApplicationCapabilities = ["ProtApp"]

                if let application = try? MSALPublicClientApplication(configuration: config!) {
                    guard let self = self else {
                        call.reject("No self")
                        return
                    }
                    let viewController = self.bridge!.viewController!
                    let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)

                    let completionBlock: MSALCompletionBlock = { (result, error) in

                        guard let authResult = result, error == nil else {
                            if let error = error as NSError? {
                                if error.code == MSALError.serverProtectionPoliciesRequired.rawValue {
                                    IntuneMAMComplianceManager.instance().remediateCompliance(forIdentity: error.userInfo[MSALDisplayableUserIdKey] as! String, silent: false)
                                }
                            }
                            print(error!.localizedDescription)
                            call.reject("Unable to login: \(error!.localizedDescription)")
                            return
                        }

                        // Get access token from result
                        let accessToken = authResult.accessToken
                        let idToken = authResult.idToken
                        guard let upn = authResult.account.username else {
                            call.reject("No username provided for account, unable to register")
                            return
                        }
                        // You'll want to get the account identifier to retrieve and reuse the account for later acquireToken calls
                        let accountIdentifier = authResult.account.identifier ?? ""

                        call.resolve([
                            "accessToken": accessToken,
                            "idToken": idToken,
                            "accountIdentifier": accountIdentifier,
                            "upn": upn
                        ])
                    }

                    if interactive {
                        let interactiveParameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webviewParameters)
                        if forcePrompt {
                            interactiveParameters.promptType = .login
                        }
                        application.acquireToken(with: interactiveParameters, completionBlock: completionBlock)
                    } else {
                        guard let account = try? application.account(forUsername: upn!) else {
                            call.reject("Unable to find account to refresh, must call acquireToken for interactive flow")
                            return
                        }
                        let silentParameters = MSALSilentTokenParameters(scopes: scopes, account: account)
                        if forceRefresh {
                            silentParameters.forceRefresh = true
                        }
                        application.acquireTokenSilent(with: silentParameters, completionBlock: completionBlock)
                    }
                } else {
                    call.reject("Unable to create MSAL Application")
                }
            }
        }
    }

    @objc public func acquireToken(_ call: CAPPluginCall) {
        _acquireToken(call, interactive: true)
    }

    @objc public func acquireTokenSilent(_ call: CAPPluginCall) {
        _acquireToken(call, interactive: false)
    }

    @objc public func registerAndEnrollAccount(_ call: CAPPluginCall) {
        guard let upn = call.getString("upn") else {
            call.reject("upn must be provided. Call acquireToken first")
            return
        }
        
        IntuneMAMEnrollmentManager.instance().delegate = EnrollmentDelegateClass() { (didSucceed: Bool, message: String) in
            if didSucceed {
                call.resolve()
            } else {
                call.reject(message)
            }
            self.resetDelegate()
        }
        // The delegate is not always called so we call deRegisterAndUnenrollAccount as a workaround
        // Example is when the user is not licensed for inTune
        // Maybe caused by this issue https://github.com/msintuneappsdk/ms-intune-app-sdk-ios/issues/178
        // IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccount(upn, withWipe: true)
        IntuneMAMEnrollmentManager.instance().registerAndEnrollAccount(upn)
    }

    @objc public func loginAndEnrollAccount(_ call: CAPPluginCall) {
        IntuneMAMEnrollmentManager.instance().delegate = EnrollmentDelegateClass() { (didSucceed: Bool, message: String) in
            if didSucceed {
                call.resolve()
            } else {
                call.reject(message)
            }
            self.resetDelegate()
        }
        IntuneMAMEnrollmentManager.instance().loginAndEnrollAccount(nil)
    }

    @objc public func enrolledAccount(_ call: CAPPluginCall) {
        let user = IntuneMAMEnrollmentManager.instance().enrolledAccount()

        call.resolve([
            "upn": user ?? ""
        ])
    }

    @objc public func deRegisterAndUnenrollAccount(_ call: CAPPluginCall) {
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }

        guard let intuneSettings = Bundle.main.object(forInfoDictionaryKey: "IntuneMAMSettings") as? [AnyHashable: AnyHashable] else {
            call.reject("IntuneMAMSettings must be set in Info.plist to use this method. See https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#configure-msal-settings-for-the-intune-app-sdk")
            return
        }

        guard let clientId = intuneSettings["ADALClientId"] as? String else {
            call.reject("ADALClientId must be specified in IntuneMAMSettings in Info.plist")
            return
        }

        let redirectUri = intuneSettings["ADALRedirectUri"] as? String
        let authorityUriValue = intuneSettings["ADALAuthority"] as? String
        var authority: MSALAuthority?
        if let authorityUri = authorityUriValue {
            if let u = URL(string: authorityUri) {
                authority = try? MSALAuthority(url: u)
            }
        }

        IntuneMAMEnrollmentManager.instance().delegate = EnrollmentDelegateClass() { (didSucceed: Bool, message: String) in
            if didSucceed {
                call.resolve()
            } else {
                call.reject(message)
            }
            self.resetDelegate()
        }
        IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccount(upn, withWipe: true)

        DispatchQueue.main.async { [weak self] in
            do {

                var config: MSALPublicClientApplicationConfig?

                if redirectUri != nil {
                    config = MSALPublicClientApplicationConfig(clientId: clientId, redirectUri: redirectUri, authority: authority)
                } else {
                    config = MSALPublicClientApplicationConfig(clientId: clientId)
                }

                config?.clientApplicationCapabilities = ["ProtApp"]
                if let application = try? MSALPublicClientApplication(configuration: config!) {
                    guard let self = self else {
                        call.reject("No self")
                        return
                    }

                    guard let account = try? application.account(forUsername: upn) else {
                        call.reject("Unable to find account to refresh, must call acquireToken for interactive flow")
                        return
                    }
                    let viewController = self.bridge!.viewController!
                    let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)

                    let signoutParameters = MSALSignoutParameters(webviewParameters: webviewParameters)
                    signoutParameters.signoutFromBrowser = false

                    application.signout(with: account, signoutParameters: signoutParameters) { (_, error) in
                        if error != nil {
                            call.reject("Unable to sign out", nil, error)
                        }
                    }
                }
            }
        }
    }

    @objc public func logoutOfAccount(_ call: CAPPluginCall) {
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }

        guard let intuneSettings = Bundle.main.object(forInfoDictionaryKey: "IntuneMAMSettings") as? [AnyHashable: AnyHashable] else {
            call.reject("IntuneMAMSettings must be set in Info.plist to use this method. See https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#configure-msal-settings-for-the-intune-app-sdk")
            return
        }

        guard let clientId = intuneSettings["ADALClientId"] as? String else {
            call.reject("ADALClientId must be specified in IntuneMAMSettings in Info.plist")
            return
        }

        let redirectUri = intuneSettings["ADALRedirectUri"] as? String
        let authorityUriValue = intuneSettings["ADALAuthority"] as? String
        var authority: MSALAuthority?
        if let authorityUri = authorityUriValue {
            if let u = URL(string: authorityUri) {
                authority = try? MSALAuthority(url: u)
            }
        }

        DispatchQueue.main.async { [weak self] in
            do {

                var config: MSALPublicClientApplicationConfig?

                if redirectUri != nil {
                    config = MSALPublicClientApplicationConfig(clientId: clientId, redirectUri: redirectUri, authority: authority)
                } else {
                    config = MSALPublicClientApplicationConfig(clientId: clientId)
                }

                config?.clientApplicationCapabilities = ["ProtApp"]
                if let application = try? MSALPublicClientApplication(configuration: config!) {
                    guard let self = self else {
                        call.reject("No self")
                        return
                    }

                    guard let account = try? application.account(forUsername: upn) else {
                        call.reject("Unable to find account to refresh, must call acquireToken for interactive flow")
                        return
                    }
                    let viewController = self.bridge!.viewController!
                    let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)

                    let signoutParameters = MSALSignoutParameters(webviewParameters: webviewParameters)
                    signoutParameters.signoutFromBrowser = false

                    application.signout(with: account, signoutParameters: signoutParameters) { (_, error) in
                        if error == nil {
                            call.resolve()
                        } else {
                            call.reject("Unable to sign out", nil, error)
                        }
                    }
                } else {
                    call.resolve()
                }
            }
        }
    }

    @objc public func appConfig(_ call: CAPPluginCall) {
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }
        let data = IntuneMAMAppConfigManager.instance().appConfig(forIdentity: upn)

        let groupNameKey = "GroupName"

        if !data.hasConflict(groupNameKey) {
            if let groupName = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.any) {
                print("Got group name here: \(groupName)")
            }
        } else {
            // Resolve the conflict by taking the max value
            let gn = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.max)!
            print("Got group name: \(gn)")
        }

        call.resolve([
            "fullData": data.fullData as Any
        ])
    }

    @objc public func groupName(_ call: CAPPluginCall) {
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }
        let data = IntuneMAMAppConfigManager.instance().appConfig(forIdentity: upn)

        let groupNameKey = "GroupName"
        var groupName: String?

        if !data.hasConflict(groupNameKey) {
            if let gn = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.any) {
                groupName = gn
            }
        } else {
            // Resolve the conflict by taking the max value
            let gn = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.max)!

            groupName = gn
        }

        call.resolve([
            "value": groupName ?? ""
        ])
    }

    @objc public func getPolicy(_ call: CAPPluginCall) {
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }

        guard let policy = IntuneMAMPolicyManager.instance().policy(forIdentity: upn) else {
            call.reject("No policy for user")
            return
        }

        // Convert their dictionary mapping of number : number to an array for json serialization
        let openFromLocations = policy.getOpenFromLocations(forAccount: upn).map { key, value in
            return [key, value]
        }

        let saveToLocations = policy.getSaveToLocations(forAccount: upn).map { key, value in
            return [key, value]
        }

        // TODO: verify copy/paste support
        call.resolve([
            "areSiriIntentsAllowed": policy.areSiriIntentsAllowed,
            "appSharingAllow": policy.isAppSharingAllowed,
            "contactSyncAllowed": policy.isContactSyncAllowed,
            "fileEncryptionRequired": policy.isFileEncryptionRequired,
            "managedBrowserRequired": policy.isManagedBrowserRequired,
            "pinRequired": policy.isPINRequired,
            "spotlightIndexingAllowed": policy.isSpotlightIndexingAllowed,
            "shouldFileProviderEncryptFiles": policy.shouldFileProviderEncryptFiles,
            "printingAvailable": UIPrintInteractionController.isPrintingAvailable,
            "openFromLocations": openFromLocations,
            "saveToLocations": saveToLocations
        ])
    }

    // Diagnostics methods:

    @objc public func sdkVersion(_ call: CAPPluginCall) {
        call.resolve([
            "version": IntuneMAMVersionInfo.sdkVersion()
        ])
    }

    @objc public func displayDiagnosticConsole(_ call: CAPPluginCall) {
        IntuneMAMDiagnosticConsole.display()
        call.resolve()
    }
}
