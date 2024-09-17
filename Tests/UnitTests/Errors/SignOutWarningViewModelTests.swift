import GDSAnalytics
import GDSCommon
@testable import OneLogin
import XCTest

@MainActor
final class SignOutWarningViewModelTests: XCTestCase {
    var mockAnalyticsService: MockAnalyticsService!
    var sut: SignOutWarningViewModel!
    
    var didCallButtonAction = false
    
    override func setUp() {
        super.setUp()
        
        mockAnalyticsService = MockAnalyticsService()
        sut = SignOutWarningViewModel(analyticsService: mockAnalyticsService) {
            self.didCallButtonAction = true
        }
    }
    
    override func tearDown() {
        mockAnalyticsService = nil
        sut = nil
        didCallButtonAction = false
    }
}

extension SignOutWarningViewModelTests {
    func test_pageConfiguration() throws {
        XCTAssertEqual(sut.title.stringKey, "app_signOutWarningTitle")
        XCTAssertEqual(sut.body, "app_signOutWarningBody")
        XCTAssertNil(sut.secondaryButtonViewModel)
        XCTAssertNil(sut.rightBarButtonTitle)
        XCTAssertTrue(sut.backButtonIsHidden)
    }
    
    func test_buttonConfiuration() throws {
        XCTAssertTrue(sut.primaryButtonViewModel is AnalyticsButtonViewModel)
        XCTAssertEqual(sut.primaryButtonViewModel.title, GDSLocalisedString(stringLiteral: "app_extendedSignInButton"))
        let button = try XCTUnwrap(sut.primaryButtonViewModel as? AnalyticsButtonViewModel)
        XCTAssertEqual(button.backgroundColor, .gdsGreen)
    }
    
    func test_buttonAction() throws {
        XCTAssertFalse(didCallButtonAction)
        XCTAssertEqual(mockAnalyticsService.eventsLogged.count, 0)
        sut.primaryButtonViewModel.action()
        XCTAssertTrue(didCallButtonAction)
        XCTAssertEqual(mockAnalyticsService.eventsLogged.count, 1)
        let event = LinkEvent(textKey: "app_extendedSignInButton",
                              linkDomain: AppEnvironment.oneLoginBaseURL,
                              external: .false)
        XCTAssertEqual(mockAnalyticsService.eventsLogged, [event.name.name])
        XCTAssertEqual(mockAnalyticsService.eventsParamsLogged["text"], event.parameters["text"])
        XCTAssertEqual(mockAnalyticsService.eventsParamsLogged["type"], event.parameters["type"])
        XCTAssertEqual(mockAnalyticsService.eventsParamsLogged["link_domain"], event.parameters["link_domain"])
        XCTAssertEqual(mockAnalyticsService.eventsParamsLogged["external"], event.parameters["external"])
    }

    func test_didAppear() {
        XCTAssertEqual(mockAnalyticsService.screensVisited.count, 0)
        sut.didAppear()
        XCTAssertEqual(mockAnalyticsService.screensVisited.count, 1)
        let screen = ScreenView(id: ErrorAnalyticsScreen.signOutWarning.rawValue,
                                screen: ErrorAnalyticsScreen.signOutWarning,
                                titleKey: "app_signOutWarningTitle")
        XCTAssertEqual(mockAnalyticsService.screensVisited, [screen.name])
        XCTAssertEqual(mockAnalyticsService.screenParamsLogged["title"], screen.parameters["title"])
        XCTAssertEqual(mockAnalyticsService.screenParamsLogged["screen_id"], screen.parameters["screen_id"])
    }
}
