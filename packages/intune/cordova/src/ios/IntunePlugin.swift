import Foundation
import IntuneMAMSwift
import MSAL

@objc(IntuneMAM)
public class IntuneMAM: CAPPlugin {
    weak var enrollmentDelegate = EnrollmentDelegateClass()
    weak var policyDelegate = PolicyDelegateClass()

    func createCall(_ command: CDVInvokedUrlCommand) -> CAPPluginCall {
        let capcall = CAPPluginCall()
        capcall.options = command.arguments.count > 0 ? command.arguments[0] as? [AnyHashable: Any] : [:]
        if capcall.options == nil {
            capcall.options = [AnyHashable: Any]()
        }
        let commandDelegate = self.commandDelegate
        let callbackId = command.callbackId

        capcall.errorHandler = { (error: CAPPluginCallError?) in
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: error?.message
            )
            commandDelegate!.send(
                pluginResult,
                callbackId: callbackId
            )
        }
        capcall.successHandler = { (result: CAPPluginCallResult?, _: CAPPluginCall?) in
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: result?.data
            )
            commandDelegate!.send(
                pluginResult,
                callbackId: callbackId
            )
        }
        return capcall
    }

    override public func pluginInitialize() {
        print("IntuneMAM Loading")
        IntuneMAMEnrollmentManager.instance().delegate = enrollmentDelegate
        IntuneMAMPolicyManager.instance().delegate = policyDelegate
        // register for the IntuneMAMAppConfigDidChange notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIntuneMAMAppConfigDidChange),
                                               name: NSNotification.Name.IntuneMAMAppConfigDidChange,
                                               object: IntuneMAMAppConfigManager.instance())

        // register for the IntuneMAMPolicyDidChange notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIntuneMAMPolicyDidChange),
                                               name: NSNotification.Name.IntuneMAMPolicyDidChange,
                                               object: IntuneMAMPolicyManager.instance())

    }

    @objc func onIntuneMAMAppConfigDidChange() {
        // Emit event
        print("AppConfig did change")
        // notifyListeners("appConfigChange", data: nil)
    }

    @objc func onIntuneMAMPolicyDidChange() {
        print("Intune policy did change")
        // notifyListeners("policyChange", data: nil)
    }

    func _acquireToken(_ call: CAPPluginCall, interactive: Bool) {

        // Used for refreshing a token
        let upn = call.getString("upn")
        if !interactive && upn == nil {
            call.reject("upn must be provided to refresh token")
            return
        }

        let forcePrompt = call.getBool("forcePrompt", false)

        guard let scopes = call.getArray("scopes", String.self) else {
            call.reject("scopes not provided")
            return
        }

        guard let intuneSettings = Bundle.main.object(forInfoDictionaryKey: "IntuneMAMSettings") as? [AnyHashable: AnyHashable] else {
            call.reject("IntuneMAMSettings must be set in Info.plist to use this method. See https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#configure-msal-settings-for-the-intune-app-sdk")
            return
        }

        guard let clientId = intuneSettings["ADALClientId"] as? String else {
            call.reject("ADALClientId must be specified in IntuneMAMSettings in Info.plist")
            return
        }

        let redirectUri = intuneSettings["ADALRedirectUri"] as? String
        let authorityUriValue = intuneSettings["ADALAuthority"] as? String

        var authority: MSALAuthority?
        if let authorityUri = authorityUriValue {
            if let u = URL(string: authorityUri) {
                authority = try? MSALAuthority(url: u)
            }
        }

        DispatchQueue.main.async { [weak self] in
            do {
                var config: MSALPublicClientApplicationConfig?

                if redirectUri != nil {
                    config = MSALPublicClientApplicationConfig(clientId: clientId, redirectUri: redirectUri, authority: authority)
                } else {
                    config = MSALPublicClientApplicationConfig(clientId: clientId)
                }

                if let application = try? MSALPublicClientApplication(configuration: config!) {
                    guard let self = self else {
                        call.reject("No self")
                        return
                    }
                    let viewController = self.viewController!
                    let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)

                    let completionBlock: MSALCompletionBlock = { (result, error) in

                        guard let authResult = result, error == nil else {
                            print(error!.localizedDescription)
                            call.reject("Unable to login: \(error!.localizedDescription)")
                            return
                        }

                        // Get access token from result
                        let accessToken = authResult.accessToken
                        let idToken = authResult.idToken
                        guard let upn = authResult.account.username else {
                            call.reject("No username provided for account, unable to register")
                            return
                        }
                        // You'll want to get the account identifier to retrieve and reuse the account for later acquireToken calls
                        let accountIdentifier = authResult.account.identifier ?? ""

                        call.resolve([
                            "accessToken": accessToken,
                            "idToken": idToken,
                            "accountIdentifier": accountIdentifier,
                            "upn": upn
                        ])
                    }

                    if interactive {
                        let interactiveParameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webviewParameters)
                        if forcePrompt {
                            interactiveParameters.promptType = .login
                        }
                        application.acquireToken(with: interactiveParameters, completionBlock: completionBlock)
                    } else {
                        guard let account = try? application.account(forUsername: upn!) else {
                            call.reject("Unable to find account to refresh, must call acquireToken for interactive flow")
                            return
                        }
                        let silentParameters = MSALSilentTokenParameters(scopes: scopes, account: account)
                        application.acquireTokenSilent(with: silentParameters, completionBlock: completionBlock)
                    }
                } else {
                    call.reject("Unable to create MSAL Application")
                }
            }
        }
    }

    @objc public func acquireToken(_ command: CDVInvokedUrlCommand) {
        _acquireToken(createCall(command), interactive: true)
    }

    @objc public func acquireTokenSilent(_ command: CDVInvokedUrlCommand) {
        _acquireToken(createCall(command), interactive: false)
    }

    @objc public func registerAndEnrollAccount(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        guard let upn = call.getString("upn") else {
            call.reject("upn must be provided. Call acquireToken first")
            return
        }

        IntuneMAMEnrollmentManager.instance().registerAndEnrollAccount(upn)

        call.resolve()
    }

    @objc public func loginAndEnrollAccount(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        IntuneMAMEnrollmentManager.instance().loginAndEnrollAccount(nil)

        call.resolve()
    }

    @objc public func enrolledAccount(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        let user = IntuneMAMEnrollmentManager.instance().enrolledAccount()

        call.resolve([
            "upn": user ?? ""
        ])
    }

    @objc public func deRegisterAndUnenrollAccount(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }

        guard let intuneSettings = Bundle.main.object(forInfoDictionaryKey: "IntuneMAMSettings") as? [AnyHashable: AnyHashable] else {
            call.reject("IntuneMAMSettings must be set in Info.plist to use this method. See https://docs.microsoft.com/en-us/mem/intune/developer/app-sdk-ios#configure-msal-settings-for-the-intune-app-sdk")
            return
        }

        guard let clientId = intuneSettings["ADALClientId"] as? String else {
            call.reject("ADALClientId must be specified in IntuneMAMSettings in Info.plist")
            return
        }

        let redirectUri = intuneSettings["ADALRedirectUri"] as? String
        let authorityUriValue = intuneSettings["ADALAuthority"] as? String
        var authority: MSALAuthority?
        if let authorityUri = authorityUriValue {
            if let u = URL(string: authorityUri) {
                authority = try? MSALAuthority(url: u)
            }
        }

        IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccount(upn, withWipe: true)

        DispatchQueue.main.async { [weak self] in
            do {

                var config: MSALPublicClientApplicationConfig?

                if redirectUri != nil {
                    config = MSALPublicClientApplicationConfig(clientId: clientId, redirectUri: redirectUri, authority: authority)
                } else {
                    config = MSALPublicClientApplicationConfig(clientId: clientId)
                }

                config?.clientApplicationCapabilities = ["ProtApp"]
                if let application = try? MSALPublicClientApplication(configuration: config!) {
                    guard let self = self else {
                        call.reject("No self")
                        return
                    }

                    guard let account = try? application.account(forUsername: upn) else {
                        call.reject("Unable to find account to refresh, must call acquireToken for interactive flow")
                        return
                    }
                    let viewController = self.viewController!
                    let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)

                    let signoutParameters = MSALSignoutParameters(webviewParameters: webviewParameters)
                    signoutParameters.signoutFromBrowser = false

                    application.signout(with: account, signoutParameters: signoutParameters) { (_, error) in
                        if error == nil {
                            call.resolve()
                        } else {
                            call.reject("Unable to sign out", nil, ["error": error!])
                        }
                    }
                } else {
                    call.resolve()
                }
            }
        }
    }

    @objc public func appConfig(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }
        let data = IntuneMAMAppConfigManager.instance().appConfig(forIdentity: upn)

        let groupNameKey = "GroupName"

        if !data.hasConflict(groupNameKey) {
            if let groupName = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.any) {
                print("Got group name here: \(groupName)")
            }
        } else {
            // Resolve the conflict by taking the max value
            let gn = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.max)!
            print("Got group name: \(gn)")
        }

        call.resolve([
            "fullData": data.fullData as Any
        ])
    }

    @objc public func groupName(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }
        let data = IntuneMAMAppConfigManager.instance().appConfig(forIdentity: upn)

        let groupNameKey = "GroupName"
        var groupName: String?

        if !data.hasConflict(groupNameKey) {
            if let gn = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.any) {
                groupName = gn
            }
        } else {
            // Resolve the conflict by taking the max value
            let gn = data.stringValue(forKey: groupNameKey, queryType: IntuneMAMStringQueryType.max)!

            groupName = gn
        }

        call.resolve([
            "value": groupName ?? ""
        ])
    }

    @objc public func getPolicy(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }

        guard let policy = IntuneMAMPolicyManager.instance().policy(forIdentity: upn) else {
            call.reject("No policy for user")
            return
        }

        // Convert their dictionary mapping of number : number to an array for json serialization
        let openFromLocations = policy.getOpenFromLocations(forAccount: upn).map { key, value in
            return [key, value]
        }

        let saveToLocations = policy.getSaveToLocations(forAccount: upn).map { key, value in
            return [key, value]
        }

        // TODO: verify copy/paste support
        call.resolve([
            "areSiriIntentsAllowed": policy.areSiriIntentsAllowed,
            "appSharingAllow": policy.isAppSharingAllowed,
            "contactSyncAllowed": policy.isContactSyncAllowed,
            "fileEncryptionRequired": policy.isFileEncryptionRequired,
            "managedBrowserRequired": policy.isManagedBrowserRequired,
            "pinRequired": policy.isPINRequired,
            "spotlightIndexingAllowed": policy.isSpotlightIndexingAllowed,
            "shouldFileProviderEncryptFiles": policy.shouldFileProviderEncryptFiles,
            "printingAvailable": UIPrintInteractionController.isPrintingAvailable,
            "openFromLocations": openFromLocations,
            "saveToLocations": saveToLocations
        ])
    }

    // Diagnostics methods:

    @objc public func sdkVersion(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        call.resolve([
            "version": IntuneMAMVersionInfo.sdkVersion()
        ])
    }

    @objc public func displayDiagnosticConsole(_ command: CDVInvokedUrlCommand) {
        let call = createCall(command)
        IntuneMAMDiagnosticConsole.display()
        call.resolve()
    }
}
