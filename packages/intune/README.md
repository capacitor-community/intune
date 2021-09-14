# @ionic-enterprise/intune

Support for Microsoft Intune

## Install

```bash
npm install @ionic-enterprise/intune
npx cap sync
```

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
