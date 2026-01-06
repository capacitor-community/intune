---
title: Usage
sidebar_label: Usage
---

**Interested in Intune support?** [Get in touch](https://ionic.io/contact/sales).

## Capacitor: Importing

Import from `@capacitor-community/intune`, for example:

```typescript
import { IntuneMAM } from '@capacitor-community/intune';
```

## Cordova: Importing, TypeScript, and Usage

Cordova developers can access `IntuneMAM` directly on `window`.

For using TypeScript, import the types as such (note the `import type`):

```typescript
import type {
  IntuneMAMPlugin,
  // If using, other types can be imported as such:
  IntuneMAMAppConfig,
  IntuneMAMGroupName,
  IntuneMAMPolicy,
  IntuneMAMUser,
  IntuneMAMVersionInfo,
} from '@capacitor-community/intune/cordova/definitions';
```

Then, when accessing `IntuneMAM`, it can be typed like this:

```typescript
const IntuneMAM = (window as any).IntuneMAM as IntuneMAMPlugin;
```

Accessing `IntuneMAM` should be done _after_ `deviceready` fires, regardless of the above.

## MSAL Acquire Token and Intune Register Flow

For apps that need access to a token from MSAL (to make authenticated requests to Microsoft graph services, for example), must follow the `acquireToken`, `acquireTokenSilent`, and `registerAndEnrollAccount` flow.

First, the user must log in using `acquireToken` which presents an interactive authentication experience, and then `registerAndEnrollAccount` should be called to enroll the user in Intune:

```typescript
// Login page component
const authInfo = await IntuneMAM.acquireToken({
  scopes: ['scope-1', 'scope-2'],
  forcePrompt: false
});

try {
   await IntuneMAM.registerAndEnrollAccount({
     accountId: authInfo.accountId,
   });
} catch (error) {
  // Handle errors
}
```

The `forcePrompt` option can be used to force the user to re-enter their login information. The default is `false`.

On successfully enrolling your application will close on iOS. If your application does not need to be managed by your company you do not need to call `registerAndEnrollAccount`.

The response from `acquireToken` and `acquireTokenSilent` will be of the form:

```typescript
export interface IntuneMAMAcquireToken {
  accountId: string;
  accessToken: string;
  accountIdentifier: string;
  idToken?: string;
}
```

Then, on subsequent loads, the app should request a token silently using `acquireTokenSilent` and passing in the `accountId` for the user. If that fails, then the app must present the interactive authentication flow again, for example:

```typescript
// Home/App component
try {
  const tokenInfo = await IntuneMAM.acquireTokenSilent({
    scopes: ['https://graph.microsoft.com/.default'],
    accountId: this.accountId,
    forceRefresh: false
  });
  setTokenInfo(tokenInfo);
} catch {
  console.error('Unable to silently acquire token, getting interactive');
  const tokenInfo = await IntuneMAM.acquireToken({
    scopes: ['https://graph.microsoft.com/.default'],
  });
  setTokenInfo(tokenInfo);
}
```

Note: You can choose to set the `forceRefresh` property to `true` to force a new token to be obtained. The default `false` will return a cached token if the token has not expired.

See the [Demo app](./demo-app) for an example of this flow.

`acquireToken` and `acquireTokenSilent` both expect a set of scopes to be provided, (for example `"https://graph.microsoft.com/.default"`).

Learn more about MSAL Scopes:

[https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-acquire-cache-tokens](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-acquire-cache-tokens)
[https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#openid-connect-scopes](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#openid-connect-scopes)

## Logging in and Enrolling Account

For apps that do not need a token from MSAL, `loginAndEnrollAccount` will authenticate and enroll the user in Intune for access to policies and configuration:

```typescript
await IntuneMAM.loginAndEnrollAccount();
```

## Get Enrolled Account

Once a user is logged in and enrolled, the accountId can be accessed with:

```typescript
const user = await IntuneMAM.enrolledAccount();

// User's ObjectID can be accessed using the accountId field:
// user.accountId
```

## Sign out and Deregister Account

To sign a user out and un-enroll them:

```typescript
await IntuneMAM.deRegisterAndUnenrollAccount(user);
```

Note: On successful un-enrollment the application will close on iOS.

## Sign out using MSAL

To sign a user out using MSAL:

```typescript
await IntuneMAM.logoutOfAccount(user);
```

Note: Unlike `deRegisterAndUnenrollAccount` this method does not wipe app data nor close the application on iOS.

## Load App Config

Access the remote app configuration:

```typescript
await IntuneMAM.appConfig(user);
```

## Get App Policy

Get the remote app policy:

```typescript
await IntuneMAM.getPolicy(user);
```

## Listen for Policy and Config changes

**Note: not yet supported for Cordova.**

To listen for remote app configuration or policy changes, the following events can be subscribed to:

```typescript
IntuneMAM.addListener('appConfigChange', () => {
  console.log('App config change here');
});
IntuneMAM.addListener('policyChange', () => {
  console.log('Policy change here');
});
```

## Get User Group Name

Get the group name of the user (if any)

```typescript
await IntuneMAM.groupName(user);
```

## Diagnostics and Debugging

Intune is a complex environment, and making it easy for users to provide diagnostics and debugging information can be very helpful.

To fetch the version of the Intune SDK in use:

```typescript
await IntuneMAM.sdkVersion();
```

To display a diagnostic console to access logs to share with your network administrator:

```typescript
await IntuneMAM.displayDiagnosticConsole();
```
