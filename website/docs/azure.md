---
title: Azure Configuration
sidebar_label: Azure Configuration
---

Much of the work in enabling Intune and Microsoft Authentication support requires configuration in Azure AD and the Microsoft Endpoint Manager.

## Registering Apps

Your apps need to be registered in Azure in two places:

First, it must be registered in Azure AD under `Azure Active Directory` -> `App registrations` -> `Your App` -> `Authentication` -> `Platform configurations`.

Additionally, the app must be registered in `Azure Active Directory` -> `Enterprise applications` -> `New Application`

To correctly configure the app, you'll need to come ready with the Signature Hash for Android and the package and bundle ids for Android/iOS.

Add new configurations for both iOS and Android as shown below (with an Android app for example):

![Android AAD MSAL Dashboard](/img/intune/android-aad-msal-config.png)

## App Registration Configuration

This page is also where the necessary Redirect URI and JSON configuration for Android will be found. Make sure to grab these values when the app is registered:

![Android AAD MSAL Config JSON](/img/intune/android-aad-msal-config-json.png)

## Enabling Brokered Authentication

Microsoft Authenticator must be enabled as an allowed authentication method in Azure under `Azure AD` -> `Security` -> `Authentication methods` -> `Policies`:

![Enable Brokered](/img/intune/aad-enable-brokered.png)

## Enable Access to the Microsoft Mobile Application Management API:

In the `API Permissions` section of the app registration in `Azure Active Directory` -> `App registrations` -> `Your app` -> `API permissions` must have access to the `Microsoft Mobile Application Management` API:

![Azure Troubleshooting 5000 ios](/img/intune/ios-troubleshooting-5000.png)

## User and Group Management

Users and Groups need to have access to the registered in in `Azure Active Directory` -> `Enterprise applications` -> `Your app` -> `Users and Groups` to make sure the correct users and groups are allowed access to the enterprise app.

![Azure Enterprise App](/img/intune/aad-users-groups.png)
