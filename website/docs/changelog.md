---
title: Intune Changelog
sidebar_label: Changelog
---


## 2.4.0

### Minor Changes

- 84b6d8f: Send scopes through to acquireToken on Android and update to MSAL 2.2.3 on Android

## 2.3.0

### Minor Changes

- Update Intune Android to 8.3.0 and iOS to 15.3.0

Changes required: On Android, users should remove the `includeExternalLibraries` configuration value from the `intunemam` configuration entry in their app's `build.gradle` file. This configuration entry has been removed from the Intune App SDK for Android.
