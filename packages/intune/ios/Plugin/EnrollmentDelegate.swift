import IntuneMAMSwift

class EnrollmentDelegateClass: NSObject, IntuneMAMEnrollmentDelegate {
    
    var presentingViewController: UIViewController?
    
    override init() {
        super.init()
        self.presentingViewController = nil
    }


    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
        if status.didSucceed {
            //If enrollment was successful, change from the current view (which should have been initialized with the class) to the desired page on the app (in this case ChatPage)
            print("EnrollmentDelegate - enrollmentRequest - did succeed")
            
        } else if IntuneMAMEnrollmentStatusCode.loginCanceled != status.statusCode {
            //In the case of a failure, log failure error status and code
            print("Enrollment result for identity \(status.identity) with status code \(status.statusCode)")
            print("Debug message: \(String(describing: status.errorString))")
            
            //Present the user with an alert asking them to sign in again.
            print("EnrollmentDelegate - enrollmentRequest - login cancelled")
        }
    }
    
    /*
     This is a method of the delegate that is triggered when an instance of this class is set as the delegate of the IntuneMAMEnrollmentManager and an unenrollment is attempted.
     The status parameter is a member of the IntuneMAMEnrollmentStatus class. This object can be used to check for the status of an attempted unenrollment.
     Logic for logout/token clearing is initiated here.
     */
    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
        // Go back to login page
        print("EnrollmentDelegate - unenrollRequest")
        
        if status.didSucceed != true {
            //In the case unenrollment failed, log error
            print("EnrollmentDelegate - did not succeed")
        }
    }
}
