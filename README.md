<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Intune</h3>
<p align="center"><strong><code>@capacitor-community/intune</code></strong></p>
<p align="center">
  Microsoft Intune MAM/MDM Capacitor Plugin
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2026?style=flat-square" />
  <a href="https://www.npmjs.com/package/@capacitor-community/intune"><img src="https://img.shields.io/npm/l/@capacitor-community/intune?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/intune"><img src="https://img.shields.io/npm/v/@capacitor-community/intune?style=flat-square" /></a>
</p>

## Maintainers

| Maintainer | GitHub | Social |
| -----------| -------| -------|
| Capacitor Community | [capacitor-community](https://github.com/capacitor-community) | |

## Installation

```bash
npm install @capacitor-community/intune
npx cap sync
```

## Configuration

### Android

This plugin requires no special configuration in `AndroidManifest.xml` beyond standard Capacitor setup. However, standard Intune configuration via `res/raw/auth_config.json` is required.

### iOS

Your `Info.plist` requires Intune configuration keys. See Microsoft documentation for details.

## Demo

A working example can be found in the [example-app](./example-app) directory.

## API

<docgen-index>

* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### addListener(...)

```typescript
addListener(eventName: 'appConfigChange', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                           |
| ------------------ | ------------------------------ |
| **`eventName`**    | <code>"appConfigChange"</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>     |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'policyChange', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                        |
| ------------------ | --------------------------- |
| **`eventName`**    | <code>"policyChange"</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>  |

**Returns:** <code>any</code>

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                      |
| ------------ | ------------------------- |
| **`remove`** | <code>() =&gt; any</code> |


#### IntuneMAMUser

| Prop      | Type                |
| --------- | ------------------- |
| **`upn`** | <code>string</code> |


#### IntuneMAMAcquireTokenOptions

| Prop         | Type            |
| ------------ | --------------- |
| **`scopes`** | <code>{}</code> |


#### IntuneMAMAcquireToken

| Prop                    | Type                |
| ----------------------- | ------------------- |
| **`accessToken`**       | <code>string</code> |
| **`accountIdentifier`** | <code>string</code> |


#### IntuneMAMAcquireTokenSilentOptions

| Prop      | Type                |
| --------- | ------------------- |
| **`upn`** | <code>string</code> |


#### IntuneMAMRegisterAndEnrollAccountOptions

| Prop      | Type                |
| --------- | ------------------- |
| **`upn`** | <code>string</code> |


#### IntuneMAMAppConfig


#### IntuneMAMGroupName

| Prop        | Type                |
| ----------- | ------------------- |
| **`value`** | <code>string</code> |


#### IntuneMAMPolicy

| Prop                         | Type                 |
| ---------------------------- | -------------------- |
| **`contactSyncAllowed`**     | <code>boolean</code> |
| **`pinRequired`**            | <code>boolean</code> |
| **`managedBrowserRequired`** | <code>boolean</code> |
| **`screenCaptureAllowed`**   | <code>boolean</code> |


#### IntuneMAMVersionInfo

| Prop          | Type                |
| ------------- | ------------------- |
| **`version`** | <code>string</code> |

</docgen-api>
