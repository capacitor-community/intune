---
title: Usage
sidebar_label: Usage
---

**Interested in Intune support?** [Get in touch](https://ionic.io/contact/sales).

## Importing

Import from `@ionic-enterprise/intune`, for example:

```typescript
import { IntuneMAM } from '@ionic-enterprise/intune';
```

## MSAL Acquire Token and Intune Register Flow

For apps that need access to a token from MSAL (to make authenticated requests to Microsoft graph services, for example), must follow the `acquireToken`, `acquireTokenSilent`, and `registerAndEnrollAccount` flow.

First, the user must log in using `acquireToken` which presents an interactive authentication experience, and then `registerAndEnrollAccount` should be called to enroll the user in Intune:

```typescript
// Login page component
const authInfo = await IntuneMAM.acquireToken({
  scopes: ['scope-1', 'scope-2'],
});

await IntuneMAM.registerAndEnrollAccount({
  upn: authInfo.upn,
});
```

The response from `acquireToken` and `acquireTokenSilent` will be of the form:

```typescript
export interface IntuneMAMAcquireToken {
  upn: string;
  accessToken: string;
  accountIdentifier: string;
}
```

Then, on subsequent loads, the app should request a token silently using `acquireTokenSilent` and passing in the `upn` for the user. If that fails, then the app must present the interactive authentication flow again, for example:

```typescript
// Home/App component
try {
  const tokenInfo = await IntuneMAM.acquireTokenSilent({
    scopes: ['https://graph.microsoft.com/.default'],
    ...user,
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

Once a user is logged in and enrolled, the upn can be accessed with:

```typescript
const user = await IntuneMAM.enrolledAccount();

// User UPN can be accessed using the upn field:
// user.upn
```

## Sign out and Deregister Account

To sign a user out and un-enroll them:

```typescript
await IntuneMAM.deRegisterAndUnenrollAccount(user);
```

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
