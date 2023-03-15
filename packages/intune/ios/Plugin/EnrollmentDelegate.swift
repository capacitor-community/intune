import IntuneMAMSwift

class EnrollmentDelegateClass: NSObject, IntuneMAMEnrollmentDelegate {

    var presentingViewController: UIViewController?
    var didSucceedCallback: ((Bool, String) -> Void)?

    init(_ didSucceedCallback: ((Bool, String) -> Void)? = nil) {
        self.didSucceedCallback = didSucceedCallback
        super.init()
    }

    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
        if status.didSucceed {
            // If enrollment was successful, change from the current view (which should have been initialized with the class) to the desired page on the app (in this case ChatPage)
            print("EnrollmentDelegate - enrollmentRequest - did succeed")
            if self.didSucceedCallback != nil {
                self.didSucceedCallback!(true, "")
            }
        } else {
            print("Enrollment result for identity \(status.identity) with status code \(status.statusCode)")
            print("Debug message: \(String(describing: status.errorString))")
            if self.didSucceedCallback != nil {
                self.didSucceedCallback!(false, String(describing: status.errorString))
            }
        }
    }

    /*
     This is a method of the delegate that is triggered when an instance of this class is set as the delegate of the IntuneMAMEnrollmentManager and an unenrollment is attempted.
     The status parameter is a member of the IntuneMAMEnrollmentStatus class. This object can be used to check for the status of an attempted unenrollment.
     Logic for logout/token clearing is initiated here.
     */
    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
        if status.didSucceed {
            // If unenrollment was successful, change from the current view (which should have been initialized with the class) to the desired page on the app (in this case ChatPage)
            print("EnrollmentDelegate - unenrollmentRequest - did succeed")
            if self.didSucceedCallback != nil {
                self.didSucceedCallback!(true, "")
            }
        } else {
            print("Unenrollment result for identity \(status.identity) with status code \(status.statusCode)")
            print("Debug message: \(String(describing: status.errorString))")
            if self.didSucceedCallback != nil {
                self.didSucceedCallback!(false, String(describing: status.errorString))
            }
        }
    }
}
