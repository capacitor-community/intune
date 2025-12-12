---
title: Intune
sidebar_label: Overview
slug: /
---

import WistiaVideo from '@site/src/components/WistiaVideo';

Ionic's Intune support makes it easy to add Intune MAM and Microsoft authentication features into your Ionic/Capacitor app, such as Intune security policies and brokered auth with Microsoft Authenticator and/or the Intune Company Portal app.

**Interested in Intune support?** [Get in touch](https://ionic.io/contact/sales).

Intune support is built and supported by the Ionic's native mobile experts and includes ongoing updates and maintenance, including new API features, patches, updates, and compatibility upgrades for new iOS & Android releases.

Starting **January 19, 2026**, Microsoft is making updates to improve the Intune mobile application management (MAM) service. To stay secure and run smoothly, the update requires apps built with XCode 26 to use [v21.1.0 - Release 21.1.0 - microsoftconnect/ms-intune-app-sdk-ios | GitHub](https://github.com/microsoftconnect/ms-intune-app-sdk-ios/releases/tag/21.1.0)
If you don't update to the latest versions, Microsoft noted that users will be blocked from launching your app.

Source: [Microsoft – What's New](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/whats-new#update-to-the-latest-intune-company-portal-for-android-intune-app-sdk-for-ios-and-intune-app-wrapper-for-ios)  

## Why use Ionic's Intune support?

Microsoft Intune is a complex product, and integrating the native Intune App SDKs for iOS and Android along with authentication is very challenging and time consuming. With Ionic's Intune support, developers can get up and running with Intune integration in their app with considerably less work and native development experience required.

Ionic's Intune support is practically drop-in ready for iOS and Android, with minimal native configuration required. The majority of the configuration required involves setting up the Azure AD and Intune policies in Azure that are unique to your organization.

## Intune App SDK vs App Wrapping Tool

Ionic's Intune support uses the Intune App SDK and is meant for apps that will build Intune functionality directly into their app at development time. It is _not_ meant for apps using the Intune App Wrapping tool which provides basic Intune support for apps that are already built. By using Ionic's Intune integration and the Intune App SDK, apps will have access to much more Intune functionality and Microsoft authentication and API access token support.
