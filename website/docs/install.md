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

## Note about SDK versions

The following installation guide is based on version 7.6.0 of the Intune App SDK for Android and 14.6.0 of the Intune App SDK for iOS, and is focused on the installation process that is compatible with Ionic's Intune support.

The official [Intune App SDK for Android](https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-android) and [Intune App SDK for iOS](https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios) installation guides from Microsoft should be consulted where necessary.

## Android Installation


### Configuring Gradle Plugin

On Android, the Intune App SDK functions by wrapping key Android API classes with Intune-managed ones, using a Gradle plugin to replace Android API class references at build time. This Gradle plugin must be manually configured in your app to enable Intune MAM features in your app.

To start, open your Capacitor app in Android Studio using one of the following commands:

```shell
npx cap open android 
# or
ionic capacitor open android
```

### Install Gradle Plugin

Next, open the `build.gradle` file for your main application (this is typically listed first and named `build.gradle (Project: android)` in the Gradle Scripts dropdown in Android Studio when opening your project).

At the top, there should be a `buildscript` definition, and two new dependencies below need to be added to the `dependencies` definition:

```gradle
buildscript {
    
    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:4.2.1'
        classpath 'com.google.gms:google-services:4.3.5'

        // ADD THIS:
        classpath "org.javassist:javassist:3.27.0-GA"
        // ADD THE REFERENCE TO THE GRADLE PLUGIN:
        classpath files("../ms-intune-app-sdk-android/GradlePlugin/com.microsoft.intune.mam.build.jar")
    }
}
```

Finally, there's an issue with the current version of the Intune App SDK for Android that requires the following maven repo for the `Duo-SDK-Feed` to be added to the `allprojects` `repositories` definition below the above `buildscript` definition:

```
allprojects {
    repositories {
        google()
        jcenter()
        maven {
            // ADD THESE TWO LINES:
            url 'https://pkgs.dev.azure.com/MicrosoftDeviceSDK/DuoSDK-Public/_packaging/Duo-SDK-Feed/maven/v1'
            name 'Duo-SDK-Feed'
        }
    }
}
```

### Setting Auth Configuration

The Intune App SDK for Android reads the JSON portion of your Azure AD auth configuration to configure the underlying Microsoft Authentication Library (MSAL).

This file must be named `auth_config.json` and placed in a new `raw` resource directory in your app. First, create the new resource directory by right-clicking on the `res` folder and choosing New -> Android Resource Directory:

![Raw Resource Directory](/img/intune/android-raw-directory-dropdown.png)

Then, in the wizard that pops up, choose `raw` from the `Resource type:` dropdown and click `OK`:

![Raw Resource Type](/img/intune/android-raw-resource-directory.png)

Finally, right click on the new `raw` directory and click New -> File. Name the file `auth_config.json` and paste in the JSON portion of the auth config found in the Azure portal. This configuration can be found in

Azure Active Directory -> App registrations -> Your App -> Authentication -> Platform configurations -> Android

When selecting `View` on a `Redirect URI` entry:

![Android AAD MSAL Config](/img/intune/android-aad-msal-config.png)

![Android AAD MSAL Config JSON](/img/intune/android-aad-msal-config-json.png)

### Setting Android Manifest Configuration

