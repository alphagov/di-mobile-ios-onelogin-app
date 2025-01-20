import LocalAuthentication

final class MockLocalAuthManager: LocalAuthenticationManager {
    var type: LocalAuthenticationType = .touchID
    
    var localAuthPresent = false
    var errorFromEnrolLocalAuth: Error?
    var userDidConsentToFaceID = true

    var didCallEnrolFaceIDIfAvailable = false

    var canUseAnyLocalAuth: Bool {
        localAuthPresent
    }
    
    func enrolFaceIDIfAvailable() async throws -> Bool {
        didCallEnrolFaceIDIfAvailable = true

        if let errorFromEnrolLocalAuth {
            throw errorFromEnrolLocalAuth
        }
        return userDidConsentToFaceID
    }
}
