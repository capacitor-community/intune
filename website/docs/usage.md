---
title: Usage
sidebar_label: Usage
---

__Interested in Intune support?__ [Get in touch](https://ionic.io/contact/sales).

## Logging in and Enrolling Account

To acquire a user token and enroll them, use `loginAndEnrollAccount`

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
