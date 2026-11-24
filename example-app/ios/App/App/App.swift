import SwiftUI
import Capacitor
import MSAL

@main
struct CapacitorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            CapacitorView()
                .ignoresSafeArea()
                .onOpenURL { url in
                    // MSAL's sign-in redirect comes back as a URL, so it gets the first look.
                    if !MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: nil) {
                        SceneDelegateProxy.shared.handle(openURL: url)
                    }
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    SceneDelegateProxy.shared.handle(userActivity: activity)
                }
        }
    }
}
