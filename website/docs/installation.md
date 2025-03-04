---
title: Installation
sidebar_label: Installation
---

Ionic's Intune integration supports [Capacitor](https://capacitorjs.com/) (strongly recommended), or Cordova.

## Capacitor

To install the Intune plugin, your app must be using Capacitor 7.0.0 or above. You must also have [an active Ionic Enterprise install key](https://ionic.io/docs/supported-plugins/setup) with access to Intune.

Once you have a key and your key has been associated with your app, install the main plugin package:

In your app, run:

```shell
npm install @ionic-enterprise/intune
```

Then make sure to sync your platforms per the [Capacitor development workflow](https://capacitorjs.com/docs/basics/workflow).

When finished, follow the steps to complete the native installation and configuration for [iOS](./ios-installation) and/or [Android](./android-installation).

## Cordova

Follow the [Cordova Installation](./cordova) guide.
