---
title: Intune Changelog
sidebar_label: Changelog
---


## 4.0.0

### Patch Changes

- 0fcc68e: fix ios bug in objc
- 0fcc68e: cordova-ios 6
- 0fcc68e: cordova fixes
- 0fcc68e: fix bridge ref
- 0fcc68e: add "add-swift-support" corova dep
- 0fcc68e: update cordova files
- 0fcc68e: fix call reject

## 4.0.0-next.8

### Patch Changes

- 7c9835a: cordova-ios 6

## 4.0.0-next.7

### Patch Changes

- chore: fix call reject

## 4.0.0-next.6

### Patch Changes

- fix bridge ref

## 4.0.0-next.5

### Patch Changes

- 89707b8: chore: fix ios bug in objc

## 4.0.0-next.4

### Patch Changes

- add "add-swift-support" corova dep

## 4.0.0-next.3

### Patch Changes

- update cordova files

## 4.0.0-next.2

### Patch Changes

- chore: cordova fixes

## 4.0.0-next.1

## 3.1.1

### Patch Changes

- a862edc: change dependency scope so library classes can be referenced from app projects

## 3.1.0

### Minor Changes

- 86f138f: Fix deRegisterAndUnenrollAccount not awaiting
- 86f138f: deRegisterAndUnenrollAccount in Android will now await properly
- 9cbaf1b: Add forceRefresh property to acquireTokenSilent
- abff059: Add logoutOfAccount() for MSAL signout only funcionality

## 3.1.0-next.3

### Minor Changes

- dcb4500: Add logoutOfAccount() for MSAL signout only funcionality

## 3.1.0-next.2

### Minor Changes

- c48fdfa: deRegisterAndUnenrollAccount in Android will now await properly

## 3.1.0-next.1

### Minor Changes

- Fix deRegisterAndUnenrollAccount not awaiting

## 3.1.0-next.0

### Minor Changes

- Add forceRefresh property to acquireTokenSilent

## 3.0.3

### Patch Changes

- 56b97e3: Fix registerAndEnrollAccount promise resolutions

## 3.0.3-next.0

### Patch Changes

- Fix registerAndEnrollAccount promise resolutions

## 3.0.2

### Patch Changes

- 8bcfa5c: Fix Promises not rejecting/resolving properly

## 3.0.2-next.0

### Patch Changes

- Fix Promises not rejecting/resolving properly

## 3.0.1

### Patch Changes

- fix ios frameworks mixed types

## 3.0.0

### Major Changes

- d147341: Update Swift SDK to 17.1.1 and MSAL SDK to 1.2.5

### Patch Changes

- 1dfb1ab: Update MSAL SDK on iOS

## 2.5.1

### Patch Changes

- ab2f5d8: Make dependencies compatible with Capacitor 4

## 2.5.0

### Minor Changes

- Add `promptType` option to allow always forcing login (See this [issue](https://github.com/AzureAD/microsoft-authentication-library-for-objc/issues/1271#issuecomment-797633677)).

## 2.4.5

### Patch Changes

- Fix release

## 2.4.4

### Patch Changes

- Fixed appconfig serialization for Android

## 2.4.3

### Patch Changes

- Log users out from MSAL on deregister

## 2.4.2

### Patch Changes

- Fix for compilation error `Direct local .aar file dependencies are not supported when building an AAR`

## 2.4.1

### Patch Changes

- Add missing Cordova scripts

## 2.4.0

### Minor Changes

- 84b6d8f: Send scopes through to acquireToken on Android and update to MSAL 2.2.3 on Android

## 2.3.0

### Minor Changes

- Update Intune Android to 8.3.0 and iOS to 15.3.0
