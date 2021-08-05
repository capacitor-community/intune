---
title: Usage
sidebar_label: Usage
---

## Logging in and Enrolling Account

To acquire a user token and enroll them, use `loginAndEnrollAccount`

```typescript
await IntuneMAM.loginAndEnrollAccount();
```

## Get Enrolled Account

```typescript
const user = await IntuneMAM.enrolledAccount();

// User UPN can be accessed using the upn field:
// user.upn
```

## Sign out and Deregister Account

```typescript
await IntuneMAM.deRegisterAndUnenrollAccount(user);
```

## Load App Config

```typescript
await IntuneMAM.appConfig(user);
```

## Get User Group Name

```typescript
await IntuneMAM.groupName(user);
```

## Get App Policy

```typescript
await IntuneMAM.getPolicy(user);
```

## Listen for Policy and Config changes

```typescript
IntuneMAM.addListener('appConfigChange', () => {
    console.log('App config change here');
});
IntuneMAM.addListener('policyChange', () => {
    console.log('Policy change here');
});
```

## Diagnostics and Debugging

Fetch the version of the Intune SDK:

```typescript
await IntuneMAM.sdkVersion();
```

Display a diagnostic console to access logs to share with your network administrator:

```typescript
await IntuneMAM.displayDiagnosticConsole();
```
