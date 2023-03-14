# @ionic-enterprise/intune

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
