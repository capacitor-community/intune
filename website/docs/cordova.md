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
ionic cordova plugin add @ionic-enterprise/intune
  --variable INTUNE_CLIENT_ID=AZURE_CLIENT_ID
  --variable INTUNE_ADAL_AUTHORITY=AZURE_ADAL_AUTHORITY
  --variable INTUNE_REDIRECT_URI_IOS=AZURE_AD_IOS_REDIRECT_URI
  --variable INTUNE_SIGNATURE_HASH=ANDROID_SIGNATURE_HASH
```

## iOS

No additional configuration necessary.

## Android

Ionic's Intune integration requires `cordova-android@10`:

```shell
cordova platform add android@10
```

Then, follow the [Creating Configuration JSON File](https://ionic.io/docs/intune/android-installation#creating-configuration-json-file) instructions to create `auth_config.json` in a `raw` Android resources folder to finish installation.
