import Capacitor
import IntuneMAMSwift

/// Settles a plugin call once, with Intune's result for the request it waits on.
class EnrollmentDelegateClass: NSObject, IntuneMAMEnrollmentDelegate {

    enum Request {
        case enroll
        case unenroll
    }

    private var call: CAPPluginCall?
    private let request: Request

    init(settling call: CAPPluginCall? = nil, on request: Request = .enroll) {
        self.call = call
        self.request = request
        super.init()
    }

    /// Returns the call if it isn't settled yet, and marks it settled. Use on the main thread.
    func takeCall() -> CAPPluginCall? {
        defer { call = nil }
        return call
    }

    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
        print("Enrollment result for accountId \(status.accountId): status code \(status.statusCode.rawValue)")
        if request == .enroll {
            settle(with: status)
        }
    }

    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
        print("Unenrollment result for accountId \(status.accountId): status code \(status.statusCode.rawValue)")
        if request == .unenroll {
            settle(with: status)
        }
    }

    private func settle(with status: IntuneMAMEnrollmentStatus) {
        DispatchQueue.main.async {
            guard let call = self.takeCall() else { return }
            if status.didSucceed {
                call.resolve()
            } else {
                call.reject(status.errorString ?? "Intune returned status \(status.statusCode.rawValue)", String(status.statusCode.rawValue))
            }
        }
    }
}
