---
title: Installation - iOS
sidebar_label: iOS
---

## iOS Installation

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
