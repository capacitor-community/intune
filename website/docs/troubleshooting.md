---
title: Troubleshooting
sidebar_label: Troubleshooting
---

## Official Troubleshooting Guide

Refer first to Microsoft's [official troubleshooting documentation](https://docs.microsoft.com/en-us/troubleshoot/mem/intune/troubleshoot-mam) to find solutions to common issues.

## iOS

### "Unexpected failure"

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

THis enables your app to launch the authenticator.

### Enable logging

See [this troubleshooting tip](https://techcommunity.microsoft.com/t5/intune-customer-success/support-tip-troubleshooting-intune-app-protection-policy-using/ba-p/330372)

## Android

### Gradle sync error: Null extracted folder for artifact

This happens when the reference to the Intune App SDK for Android AAR file (Microsoft.Intune.MAM.SDK.aar) cannot be found.

### android.content.pm.PackageManager$NameNotFoundException com.azure.authenticator

This error happens on Android 30 when your `AndroidManifest.xml` is missing `<queries>` for the Microsoft Authenticator or Intune Company Portal apps.

This is a new Android security feature (as of Android 30) that restrict the app to query for only a defined set of external apps.

To fix this issue, follow the Android install guide for the `AndroidManifest.xml` instructions to ensure the proper `<queries>` definition has been added.
