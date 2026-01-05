---
title: Azure Configuration
sidebar_label: Azure Configuration
---

Much of the work in enabling Intune and Microsoft Authentication support requires configuration in Azure AD and the Microsoft Endpoint Manager.

This list of tasks can be shared with your Azure administrator if necessary to help correctly configure the backend to enable Intune and Microsoft Authentication to work correctly.

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

## Creating App Protection Policies

To enforce Intune app protection policies for your application:

1. Navigate to the Microsoft Endpoint Manager admin center at [endpoint.microsoft.com](https://endpoint.microsoft.com)
2. Go to **Apps** → **App protection policies**
3. Click **Create policy** and select the appropriate platform (iOS/iPadOS or Android)
4. Complete the policy creation wizard:
   - On **Step 1**, provide a name and description for your policy
   - On **Step 2 (Apps)**, click **Add apps** and select **Custom app**
   - Enter your app's bundle ID (for iOS) or package name (for Android)
   - On subsequent steps, configure the desired protection settings, data protection, access requirements, and conditional launch settings
   - On **Step 6 (Assignments)**, assign the policy to the appropriate user groups that will use your application
5. Review your settings and click **Create** to finalize the policy

These policies will be applied to your app when users with assigned policies sign in to your Intune-enabled application.
