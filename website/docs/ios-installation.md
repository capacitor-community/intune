---
title: Installation - iOS
sidebar_label: iOS
---

The following steps attempt to distill the [official Intune App SDK iOS integration documentation](https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#build-the-sdk-into-your-mobile-app) to the basics needed to integrate into your Ionic/Capacitor app. Please refer to that documentation for the most up-to-date authoritative installation instructions.

## 1. Add Frameworks

The Intune App SDK requires the following Core iOS frameworks be added to your app project:

![iOS Frameworks](/img/intune/ios-frameworks.png)

## 2. Configure Keychain

Add the following keychain groups under Signing &amp; Capabilities, making sure to substitute your app's Bundle ID for the first group:

![iOS Keychain](/img/intune/ios-keychain.png)

## 3. Enable Application Queries Schemes

Open `Info.plist` and add a new Row with the name `LSApplicationQueriesSchemes` of type `Array` containing all of the protocols your app will attempt to open, for example by using the [App Launcher](https://capacitorjs.com/docs/apis/app-launcher) API in Capacitor.

Any custom protocols your app launches must have two entries: the original protocol and a new one with `-intunemam` appended.

Additionally, the following intune-specific protocols must be added :

![iOS Application Queries Schemes](/img/intune/ios-queries-schemes.png)

## 4. Set a NSFaceIDUsageDescription

To enable Face ID support, add a description for `NSFaceIDUsageScription` also known as `Privacy - Face ID Usage Description` in `Info.plist`

## 5. Update Target iOS Version

The Intune App SDK only supports iOS 12.2 and above, make sure to set the Deployment target for your app to 12.2 or higher:

![iOS 12.2](/img/intune/ios-12.png)

## 6. Disable Bitcode

The Intune App SDK does not support Bitcode. In the Build Settings for your app in Xcode, set `Strip Swift Symbols` and `Enable Bitcode` to `NO`:

![Disable bitcode](/img/intune/ios-disable-bitcode.png)

![No strip symbols](/img/intune/ios-no-strip-symbols.png)

Also add these lines to the `Podfile` in your app's `ios/App` directory. This will make sure bitcode is not enabled on any Pod targets:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

## 7. Run IntuneMAMConfigurator

As a final step, Microsoft has provided a command line utility to finish configuring your app. To use it, [follow step #7](https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#build-the-sdk-into-your-mobile-app) on the official SDK integration docs from Microsoft.

For example, the command might look like:

```shell
/path/to/ms-intune-app-sdk-ios-14.6.0/IntuneMAMConfigurator -i ios/App/App/Info.plist -e ios/App/App/App.entitlements
```

## 8. Configure MSAL

MSAL configuration is required to enable brokered auth and other common Azure Active Directory authentication integrations.

Follow the [MSAL Configuration](https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#configure-msal-settings-for-the-intune-app-sdk) docs to finish setting up MSAL in your app.

Additionally, in `AppDelegate.swift`, `import MSAL` and override the `application(_:open:options:)` method:

```swift
import MSAL

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Called when the app was launched with a url. Feel free to add additional processing here,
        // but if you want the App API to support tracking app url opens, make sure to keep this call
        // return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
        return MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
    }
```
