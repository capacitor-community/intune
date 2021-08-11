import IntuneMAMSwift

class PolicyDelegateClass: NSObject, IntuneMAMPolicyDelegate {
    func wipeData(forAccount: String) -> Bool {
        //variable to track if the data wipe was successful
        var wipeSuccess = true
        return wipeSuccess
    }
    
    func restartApplication() -> Bool {
        // Stuff you might do before restart
        return false
    }
}
