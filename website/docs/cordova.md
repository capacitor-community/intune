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

Cordova support is available starting in 1.2.0 and 2.1.0. Version 1.2.0 should be used for teams targeting iOS < 15. 2.1.0 requires Xcode 13 and enables teams to target iOS 15.

```shell
cordova plugin add @ionic-enterprise/intune --save
# or if in an Angular app:
ionic cordova plugin add @ionic-enterprise/intune
```

## iOS

### Configuring Project

See the [iOS Installation](./ios-installation) guide and follow Steps 1-6 to configure your app project. Note the two extra steps required below:

### Swift and Bridging Header

Open your project in Xcode and click on your project in the sidebar, then choose `Build Settings`, and search for "swift". Then, set the `Swift Language Version` to `4.2`.

Finally, open `Bridging-Header.h` and add:

```objc
#import "CAPPlugin.h"
#import "CAPPluginCall.h"
```

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

Follow the [Android](./android-installation) installation guide, skipping any Capacitor-specific instructions to configure your Android project to use Intune.
