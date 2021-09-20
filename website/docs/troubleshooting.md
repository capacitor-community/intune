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

### Gradle sync error: Null extracted folder for artifact

This happens when the reference to the Intune App SDK for Android AAR file (Microsoft.Intune.MAM.SDK.aar) cannot be found.

### android.content.pm.PackageManager$NameNotFoundException com.azure.authenticator

This error happens on Android 30 when your `AndroidManifest.xml` is missing `<queries>` for the Microsoft Authenticator or Intune Company Portal apps.

This is a new Android security feature (as of Android 30) that restrict the app to query for only a defined set of external apps.

To fix this issue, follow the Android install guide for the `AndroidManifest.xml` instructions to ensure the proper `<queries>` definition has been added.
