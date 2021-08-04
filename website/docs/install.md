---
title: Installation
sidebar_label: Installation
---

import NativeEnterpriseInstall from '@site/src/components/NativeEnterpriseInstall';

<!-- __Don't have an Intune subscription?__ [Try it free now](http://dashboard.ionicframework.com/personal/apps?native_trial=1). -->

Follow these steps to install Ionic's Intune integration into your app.

<NativeEnterpriseInstall pluginId="intune" variables="" />

Update the native project config files:

```xml
```

## Installing Intune SDK

Microsoft doesn't allow distributing the Intune App SDK in other packages, so it must be installed manually.

To do so, review the README, license terms, and privacy policy of the official Intune App SDKs and download the latest release of each:

 * Android: [ms-intune-app-sdk-android](https://github.com/msintuneappsdk/ms-intune-app-sdk-android)
 * iOS: [ms-intune-app-sdk-ios](https://github.com/msintuneappsdk/ms-intune-app-sdk-ios)

## Android: Configuring Gradle Plugin

On Android, the Intune App SDK functions by wrapping key Android API classes with Intune-managed ones, using a Gradle plugin to replace Android API class references at build time. This Gradle plugin must be manually configured in your app to enable Intune MAM features in your app.