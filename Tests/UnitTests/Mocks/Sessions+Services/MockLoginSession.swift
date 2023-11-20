import Authentication
import UIKit

final class MockLoginSession: LoginSession {
    let window: UIWindow
    var didCallPresent = false
    var didCallFinalise = false
    var didCallCancel = false
    var sessionConfiguration: LoginSessionConfiguration?
    
    init(window: UIWindow = UIWindow()) {
        self.window = window
    }
    
    func present(configuration: LoginSessionConfiguration) {
        didCallPresent = true
        sessionConfiguration = configuration
    }
    
    func finalise(callback: URL, endpoint: URL) throws -> TokenResponse {
        didCallFinalise = true
        return try MockTokenResponse().getJSONData()
    }
    
    func cancel() {
        didCallCancel = true
    }
}
