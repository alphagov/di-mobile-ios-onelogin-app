import Foundation
@testable import OneLogin
import XCTest

final class AppEnvironmentTests: XCTestCase {
    func test_appEnvironmentValues() throws {
        let sut = AppEnvironment.self
        XCTAssertEqual(sut.oneLoginAuthorize, URL(string: "https://auth-stub.mobile.build.account.gov.uk/authorize"))
        XCTAssertEqual(sut.oneLoginToken, URL(string: "https://mobile.build.account.gov.uk/token"))
        XCTAssertEqual(sut.privacyPolicyURL, URL(string: "https://signin.account.gov.uk/privacy-notice?lng=en"))
        XCTAssertEqual(sut.manageAccountURL, URL(string: "https://signin.account.gov.uk/sign-in-or-create?lng=en"))
        XCTAssertEqual(sut.oneLoginClientID, "TEST_CLIENT_ID")
        XCTAssertEqual(sut.oneLoginRedirect, "https://mobile.build.account.gov.uk/redirect")
        XCTAssertEqual(sut.oneLoginBaseURL, "mobile.build.account.gov.uk")
        XCTAssertEqual(sut.stsAuthorize, URL(string: "https://token.build.account.gov.uk/authorize"))
        XCTAssertEqual(sut.stsToken, URL(string: "https://token.build.account.gov.uk/token"))
        XCTAssertEqual(sut.stsHelloWorld, URL(string: "https://hello-world.token.build.account.gov.uk/hello-world"))
        XCTAssertEqual(sut.stsHelloWorldError, URL(string: "https://hello-world.token.build.account.gov.uk/hello-world/error"))
        XCTAssertEqual(sut.jwskURL, URL(string: "https://token.build.account.gov.uk/.well-known/jwks.json"))
        XCTAssertEqual(sut.stsClientID, "bYrcuRVvnylvEgYSSbBjwXzHrwJ")
        XCTAssertEqual(sut.isLocaleWelsh, false)
        XCTAssertEqual(sut.appStoreURL, URL(string: "https://apps.apple.com"))
        XCTAssertEqual(sut.appStore, URL(string: "https://apps.apple.com/gb.app.uk.gov.digital-identity"))
        XCTAssertTrue(sut.callingSTSEnabled)
        XCTAssertFalse(sut.isLocaleWelsh)
    }
    
    func test_defaultEnvironment_addingReleaseFlags() {
        // GIVEN no release flags from AppInfo end point
        // pass in release flags to enviroment
        
        let releaseFlag = AppEnvironment.updateReleaseFlags(["test1": true, "test2": false])
        
        // THEN the flags are set in environment
        XCTAssertEqual(AppEnvironment.value(for: "test1", provider: releaseFlag), true)
        XCTAssertEqual(AppEnvironment.value(for: "test2", provider: releaseFlag), false)
        
        let shouldBeNil: Bool? = AppEnvironment.value(for: "shouldBeNil", provider: ReleaseFlags())
        XCTAssertNil(shouldBeNil)
    }
    
    func test_defaultEnvironment_removingReleaseFlags() {
        // GIVEN there are release flags in Environment
        var releaseFlag = AppEnvironment
            .updateReleaseFlags(["test1": true, "test2": false])

        // WHEN updated to remove release flags from enviroment
        releaseFlag = AppEnvironment.updateReleaseFlags([:])

        // THEN the release flags are unset in the environment
        let testFlag1: Bool? = AppEnvironment.value(for: "test1", provider: releaseFlag)
        XCTAssertNil(testFlag1)

        let testFlag2: Bool? = AppEnvironment.value(for: "test2", provider: releaseFlag)
        XCTAssertNil(testFlag2)
    }
}
