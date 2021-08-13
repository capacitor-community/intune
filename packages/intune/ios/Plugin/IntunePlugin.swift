import Foundation
import Capacitor
import IntuneMAMSwift

@objc(IntuneMAM)
public class IntuneMAM: CAPPlugin {
    let enrollmentDelegate = EnrollmentDelegateClass()
    let policyDelegate = PolicyDelegateClass()
    
    override public func load() {
        print("IntuneMAM Loading")
        IntuneMAMEnrollmentManager.instance().delegate = enrollmentDelegate
        IntuneMAMPolicyManager.instance().delegate = policyDelegate
        //register for the IntuneMAMAppConfigDidChange notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIntuneMAMAppConfigDidChange),
                                               name: NSNotification.Name.IntuneMAMAppConfigDidChange,
                                               object: IntuneMAMAppConfigManager.instance())
        
        //register for the IntuneMAMPolicyDidChange notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onIntuneMAMPolicyDidChange),
                                               name: NSNotification.Name.IntuneMAMPolicyDidChange,
                                               object: IntuneMAMPolicyManager.instance())
        
    }
    
    @objc func onIntuneMAMAppConfigDidChange() {
        // Emit event
        print("AppConfig did change")
        notifyListeners("appConfigChange", data: nil)
    }
    
    @objc func onIntuneMAMPolicyDidChange() {
        print("Intune policy did change")
        notifyListeners("policyChange", data: nil)
    }
    
    @objc public func loginAndEnrollAccount(_ call: CAPPluginCall) {
        IntuneMAMEnrollmentManager.instance().loginAndEnrollAccount(nil)
        
        call.resolve()
    }
    
    @objc public func enrolledAccount(_ call: CAPPluginCall) {
        let user = IntuneMAMEnrollmentManager.instance().enrolledAccount()
        
        call.resolve([
            "upn": user ?? ""
        ])
    }
    
    @objc public func deRegisterAndUnenrollAccount(_ call: CAPPluginCall) {
        guard let upn = call.getString("upn") else {
            call.reject("No upn provided")
            return
        }
        IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccount(upn, withWipe: true)
    }
    
    @objc public func appConfig(_ call: CAPPluginCall) {
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
    
    @objc public func groupName(_ call: CAPPluginCall) {
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
    
    @objc public func getPolicy(_ call: CAPPluginCall) {
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
    
    @objc public func sdkVersion(_ call: CAPPluginCall) {
        call.resolve([
            "version": IntuneMAMVersionInfo.sdkVersion()
        ])
    }
    
    @objc public func displayDiagnosticConsole(_ call: CAPPluginCall) {
        IntuneMAMDiagnosticConsole.display()
        call.resolve()
    }
}
