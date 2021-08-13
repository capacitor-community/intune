---
title: Installation - iOS
sidebar_label: iOS
---

## Frameworks

The Intune App SDK requires the following Core iOS frameworks be added to your app project:

![iOS Frameworks](/img/intune/ios-frameworks.png)

## Target iOS Version

The Intune App SDK only supports iOS 12.2 and above, make sure to set the Deployment target for your app to 12.2 or higher:

![iOS 12.2](/img/intune/ios-12.png)

## Disable Bitcode

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
