---
title: Troubleshooting
sidebar_label: Troubleshooting
---

## Android

### Gradle sync error: Null extracted folder for artifact

This happens when the reference to the Intune App SDK for Android AAR file (Microsoft.Intune.MAM.SDK.aar) cannot be found.

### android.content.pm.PackageManager$NameNotFoundException com.azure.authenticator

This error happens on Android 30 when your `AndroidManifest.xml` is missing `<queries>` for the Microsoft Authenticator or Intune Company Portal apps.

This is a new Android security feature (as of Android 30) that restrict the app to query for only a defined set of external apps.

To fix this issue, follow the Android install guide for the `AndroidManifest.xml` instructions to ensure the proper `<queries>` definition has been added.
