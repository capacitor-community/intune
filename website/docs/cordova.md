---
title: Cordova Installation
sidebar_label: Cordova Installation
---

For teams using Cordova instead of [Capacitor](https://capacitorjs.com/), follow the below instructions to install and configure the plugin.

Note: We strongly recommend teams transition to [Capacitor](https://capacitorjs.com/) for the best experience with this and other Ionic native solutions.

## Important

Intune is a configuration-heavy service, and it is not feasible to create a Cordova plugin that automatically configures your app. Because of this, you _must_ check in your platforms folders to your code repository to avoid losing configuration changes. Do _not_ blow away your platforms folders (i.e. with `cordova platform rm`) unless you are ready to reconstruct the following configuration. Double check your `.gitignore` to make sure `platforms/` is not ignored.

## Install the Plugin

This plugin requires Cordova 10. Once you are running the latest version of Cordova, install the plugin:

```shell
cordova plugin add cordova-plugin-add-swift-support --save
cordova plugin add @ionic-enterprise/intune@1.2 --save
# or if in an Angular app:
ionic cordova plugin add cordova-plugin-add-swift-support --save
ionic cordova plugin add @ionic-enterprise/intune@1.x
```

## iOS

### Configuring Project

See the [./ios-installation](iOS Installation) guide and follow Steps 1-6 to configure your app project.

### AppDelegate

Open `AppDelegate.m` and add the `<MSAL/MSAL.h>` import and `application:openURL` handler below such that it looks something like this:

```objc
#import "AppDelegate.h"
#import "MainViewController.h"
#import <MSAL/MSAL.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.viewController = [[MainViewController alloc] init];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [MSALPublicClientApplication handleMSALResponse:url sourceApplication:[options valueForKey:UIApplicationOpenURLOptionsSourceApplicationKey]];
}

@end
```

## Android

Ionic's Intune integration requires `cordova-android@10`:

```shell
cordova platform add android@10
```

### Configuring Gradle Plugin

On Android, the Intune App SDK functions by wrapping key Android API classes with Intune-managed ones, using a Gradle plugin to replace Android API class references at build time. This Gradle plugin must be manually configured in your app to enable Intune MAM features in your app.

### Install Gradle Plugin

Next, open the `build.gradle` file for your main application (this is typically listed first and named `build.gradle (Project: android)` in the Gradle Scripts dropdown in Android Studio when opening your project).

At the top, there should be a `buildscript` definition, and two new dependencies below need to be added to the `dependencies` definition:

```groovy
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
        classpath files("./app/src/main/libs/com.microsoft.intune.mam.build.jar")
    }
}
```

### Setting Auth Configuration

Configuring Auth involves two steps: finding your app's signing signature hash, and copying the MSAL config for your app's Redirect URIs from Azure AD

#### Finding the Signature Hash

MSAL requires your app's signature hash in order to correctly use your app's Redirect URIs. To find this hash, read the [MSAL FAQ for Redirect URI Issues](https://github.com/AzureAD/microsoft-authentication-library-for-android/wiki/MSAL-FAQ#redirect-uri-issues).

If you are still struggling to find the correct hash for your app, this code may be dropped into the `MainActivity` `onCreate` method to log the package hash key for development, but keep in mind this should only be used for development mode. For production, follow the above FAQ:

```java
try {
    PackageInfo info = getPackageManager().getPackageInfo("your.package.name", PackageManager.GET_SIGNATURES);
    for (Signature signature : info.signatures) {
        MessageDigest md;
        md = MessageDigest.getInstance("SHA");
        md.update(signature.toByteArray());
        String something = new String(Base64.encode(md.digest(), 0));
        Log.e("hash key", something);
    }
} catch (Exception e) {
    Log.e("exception", e.toString());
}
```

Once you have the correct hash, register your Redirect URI in the Azure AD dashboard:

[Android AAD MSAL Dashboard](/img/intune/android-aad-msal-config.png)

#### Creating Configuration JSON File

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
