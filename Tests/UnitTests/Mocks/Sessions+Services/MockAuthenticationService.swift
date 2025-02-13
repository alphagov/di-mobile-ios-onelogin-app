import Authentication
import Foundation
@testable import OneLogin
import UIKit

final class MockAuthenticationService: AuthenticationService {
    private let sessionManager: SessionManager

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func start() async throws {
        try await sessionManager.startSession(
            MockLoginSession(window: UIWindow()),
            using: {
                _ in try await MockLoginSessionConfiguration.oneLoginSessionConfiguration()
            }
        )
    }
    
    func handleUniversalLink(_ url: URL) throws {
        throw AuthenticationError.generic
    }
}
