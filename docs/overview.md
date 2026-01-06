---
title: Intune
sidebar_label: Overview
slug: /
---

import WistiaVideo from '@site/src/components/WistiaVideo';

This plugin provides Intune support for [Capacitor](https://capacitorjs.com/), making it easy to add Intune MAM and Microsoft authentication features into your Ionic/Capacitor app, such as Intune security policies and brokered auth with Microsoft Authenticator and/or the Intune Company Portal app.

**Interested in enterprise Intune support?** [Get in touch](https://ionic.io/contact/sales).

Starting **January 19, 2026**, Microsoft is making updates to improve the Intune mobile application management (MAM) service. To stay secure and run smoothly, the update requires apps built with XCode 26 to use [v21.1.0 - Release 21.1.0 - microsoftconnect/ms-intune-app-sdk-ios | GitHub](https://github.com/microsoftconnect/ms-intune-app-sdk-ios/releases/tag/21.1.0)
If you don't update to the latest versions, Microsoft noted that users will be blocked from launching your app.

Source: [Microsoft – What's New](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/whats-new#update-to-the-latest-intune-company-portal-for-android-intune-app-sdk-for-ios-and-intune-app-wrapper-for-ios)  

## Intune App SDK vs App Wrapping Tool

This plugin uses the Intune App SDK and is meant for apps that will build Intune functionality directly into their app at development time. It is _not_ meant for apps using the Intune App Wrapping tool which provides basic Intune support for apps that are already built. By using this plugin and the Intune App SDK, apps will have access to much more Intune functionality and Microsoft authentication and API access token support.
