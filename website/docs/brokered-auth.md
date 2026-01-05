---
title: Brokered Auth
sidebar_label: Brokered Auth
---

Itune supports Brokered Auth through the Microsoft Authentication Library (MSAL), enabling users to authenticate with Microsoft Authenticator or the Intune Company Portal app.

## Enabling Brokered Auth in Azure AD

Enabling Brokered authentication starts in Azure in the Azure AD dashboard, and must be specifically turned on as an authentication option.

To find this page in Azure, navigate to Azure AD -> Security -> Authentication methods -> Policies.

![Enable Brokered](/img/intune/aad-enable-brokered.png)


## Android
Brokered auth must be enabled locally in your MSAL config (located in `android/res/raw/auth_config.json` created in [this](https://ionic.io/docs/intune/android-installation#creating-configuration-json-file) step). Add this line:

```json
"broker_redirect_uri_registered": true
```

Ensure the correct `<queries>` have been added to the `AndroidManifest.xml` by following the Android Installation [instructions](android-installation).

## iOS

No further configuration is required to enable Brokered Auth.


