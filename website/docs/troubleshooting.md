---
title: Troubleshooting
sidebar_label: Troubleshooting
---

## Official Troubleshooting Guide

Refer first to Microsoft's [official troubleshooting documentation](https://docs.microsoft.com/en-us/troubleshoot/mem/intune/troubleshoot-mam) to find solutions to common issues.

Additionally, for authentication issues, the `Sign-in logs` section of the Azure Active Directory app registration portal often has helpful error messages that point to Azure-side configuration issues. Please contact your administrator for access to this resource in Azure.

## iOS

### "Unexpected failure" when performing brokered auth

This error is the same as the one mentioned in [this issue](https://github.com/msintuneappsdk/ms-intune-app-sdk-ios/issues/175).

To fix it, some additional configuration for MSAL is required. Make sure you've added the following line inside of the `CFBundleURLSchemes` as shown below to your `Info.plist` to enable using the authenticator app:

```xml
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
        <!-- The important line -->
        <string>msauth.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
			</array>
		</dict>
	</array>
```

This enables your app to launch the authenticator.

### MSALErrorDomain -50000 when using brokered auth

This is a configuration issue in the Azure Active Directory Portal. Ensure the app registration has permission to access the `Microsoft Mobile Application Management` API. Please contact your administrator to enable your app to access the necessary APIs.

Another thing to try is setting `AutoEnrollOnLaunch` to `1` in the `IntuneMAMSettings` in `Info.plist`.

![Azure Troubleshooting 5000 ios](/img/intune/ios-troubleshooting-5000.png)

### Build error: Undefined symbols and 12.0 deployment target warning

If you see this error:

![intune undefined symbols](/img/intune/ios-troubleshooting-undefined-symbols.png)

The issue could be not setting the minimum deployment target for your App to 12.2 or above or the Podfile extra script to disable bitcode in all targets was not added.

See the [iOS Installation](./ios-installation) guide and follow the deployment target and Podfile recommendations to resolve the issue.

### Enable logging

See [this troubleshooting tip](https://techcommunity.microsoft.com/t5/intune-customer-success/support-tip-troubleshooting-intune-app-protection-policy-using/ba-p/330372)

## Android

### com.microsoft.identity.client.exception.MsalClientException: The redirect URI in the configuration file doesn't match

The error `com.microsoft.identity.client.exception.MsalClientException: The redirect URI in the configuration file doesn't match with the one generated with package name and signature hash. Please verify the uri in the config file and your app registration in Azure portal.` is thrown when attempting to authenticate using `acquireToken` or `loginAndEnrollAccount`.

This issue is thrown because the hash used for your redirect uri in `auth_config.json` and/or `AndroidManifest.xml` isn't correct. Follow the [Android installation](./android-installation) guide to find and set the correct hash for your app.

### Gradle sync error: Null extracted folder for artifact

This happens when the reference to the Intune App SDK for Android AAR file (Microsoft.Intune.MAM.SDK.aar) cannot be found.

### android.content.pm.PackageManager$NameNotFoundException com.azure.authenticator

This error happens on Android 30 when your `AndroidManifest.xml` is missing `<queries>` for the Microsoft Authenticator or Intune Company Portal apps.

This is a new Android security feature (as of Android 30) that restrict the app to query for only a defined set of external apps.

To fix this issue, follow the Android install guide for the `AndroidManifest.xml` instructions to ensure the proper `<queries>` definition has been added.

### Direct local .aar file dependencies are not supported when building an AAR.

This compilation error can happen with versions of the plugin 2.4.1 and below. Update to the latest version then open the `build.gradle` file for the `Module: android.app` and ensure it contains the following line in `dependencies`:
```groovy
dependencies {
    ...
    implementation files("../../node_modules/@ionic-enterprise/intune/android/ms-intune-app-sdk-android/Microsoft.Intune.MAM.SDK.aar")
}
``` 

### java.lang.ClassNotFoundException: Didn't find class "com.ionicframework.intune.IntuneApplication"
This runtime error can occur if you have forgotten to add the following line to the `dependencies` of the `build.gradle` file for the `Module: android.app`:
```groovy
dependencies {
    ...
    implementation files("../../node_modules/@ionic-enterprise/intune/android/ms-intune-app-sdk-android/Microsoft.Intune.MAM.SDK.aar")
}
```

### MAM Enabled: No when uploading to Microsoft Endpoint Manager
When uploading a release build APK to the Microsoft Endpoint Manager and it reports "MAM Enabled: No" then you can workaround this by editing the `gradle.properties` file and adding the following line:
```groovy
android.enableResourceOptimizations=false
```
Then create a new release build and upload the APK. It should report "MAM Enabled: Yes". This [issue](https://github.com/msintuneappsdk/ms-intune-app-sdk-android/issues/117) is related to Microsoft Endpoint Manager and is not a problem with your application.

### Incompatible Gradle Version detected
This error can occur when upgrading from 2.x to 3.x of the plugin. It is usually related to version 7.2.1 of the build tools which you can verify in `android/build.gradle`. 

To fix the problem open this file and change the line:

`classpath 'com.android.tools.build:gradle:7.2.1'` to

`classpath 'com.android.tools.build:gradle:7.2.2'`

The full error is: `incompatible Gradle version detected. Use 7.1.3 or 7.2.2+. For details, see https://issuetracker.google.com/issues/232438924`
This issue should be resolved in an upcoming version of Android Studio (Android Studio Dolphin 2021.3.1.11, yet to be released as of December 2022).

## Client Side Errors

### The account is licensed for intune but is not targeted with mam policy

This can occur with the following scenarios:
- The end user must have an Azure Active Directory (AAD) account. See Add users and give administrative permission to Intune to learn how to create Intune users in Azure Active Directory.
- The end user must have a license for Microsoft Intune assigned to their Azure Active Directory account. See Manage Intune licenses to learn how to assign Intune licenses to end users.
- The end user must belong to a security group that is targeted by an app protection policy. The same app protection policy must target the specific app being used. App protection policies can be created and deployed in the Intune console ([endpoint.microsoft.com](https://endpoint.microsoft.com/) > `Apps` > `App Protection Policies`).
- The end user must sign into the app using their AAD account.

### The operation could not be completed because the user is not licensed for MAM

This error will occur if the user has logged in with the correct credentials but their user has not been assigned a license for inTune.

You can assign a license to a user in [endpoint.microsoft.com](https://endpoint.microsoft.com/) > `Users` > Find the User > `Licenses`.
