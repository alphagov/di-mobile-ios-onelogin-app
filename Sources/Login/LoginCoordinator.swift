import Authentication
import Coordination
import GDSCommon
import LocalAuthentication
import Logging
import SecureStore
import UIKit

final class LoginCoordinator: NSObject,
                              AnyCoordinator,
                              NavigationCoordinator,
                              ChildCoordinator {
    let windowManager: WindowManagement
    let root: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    var childCoordinators = [ChildCoordinator]()
    let analyticsCenter: AnalyticsCentral
    let networkMonitor: NetworkMonitoring
    var userStore: UserStorable
    let tokenHolder: TokenHolder
    private let viewControllerFactory = OnboardingViewControllerFactory.self
    private let errorPresenter = ErrorPresenter.self
    private weak var authCoordinator: AuthenticationCoordinator?
    weak var introViewController: IntroViewController?
    private var tokenVerifier: TokenVerifier
    var tokenReadError: Error?
    
    init(windowManager: WindowManagement,
         root: UINavigationController,
         analyticsCenter: AnalyticsCentral,
         networkMonitor: NetworkMonitoring,
         userStore: UserStorable,
         tokenHolder: TokenHolder,
         tokenVerifier: TokenVerifier = JWTVerifier()) {
        self.windowManager = windowManager
        self.root = root
        self.analyticsCenter = analyticsCenter
        self.networkMonitor = networkMonitor
        self.userStore = userStore
        self.tokenHolder = tokenHolder
        self.tokenVerifier = tokenVerifier
        root.modalPresentationStyle = .overFullScreen
    }
    
    func start() {
        if userStore.returningAuthenticatedUser {
            returningUserFlow()
        } else {
            userStore.refreshStorage(accessControlLevel: LAContext().isPasscodeOnly ? .anyBiometricsOrPasscode : .currentBiometricsOrPasscode)
            firstTimeUserFlow()
        }
    }
    
    func returningUserFlow() {
        windowManager.displayUnlockWindow(analyticsService: analyticsCenter.analyticsService) { [unowned self] in
            getIdToken()
        }
        getIdToken()
    }
    
    func getIdToken() {
        Task {
            await MainActor.run {
                do {
                    guard let idToken = try userStore.secureStoreService.readItem(itemName: .idToken) else {
                        throw SecureStoreError.unableToRetrieveFromUserDefaults
                    }
                    tokenHolder.idTokenPayload = try tokenVerifier.extractPayload(idToken)
                    windowManager.hideUnlockWindow()
                    root.dismiss(animated: false)
                    finish()
                } catch {
                    userStore.refreshStorage(accessControlLevel: LAContext().isPasscodeOnly ? .anyBiometricsOrPasscode : .currentBiometricsOrPasscode)
                    windowManager.hideUnlockWindow()
                    tokenReadError = error
                    start()
                }
            }
        }
    }
    
    func firstTimeUserFlow() {
        let rootViewController = viewControllerFactory
            .createIntroViewController(analyticsService: analyticsCenter.analyticsService) { [unowned self] in
                if networkMonitor.isConnected {
                    launchAuthenticationCoordinator()
                } else {
                    let networkErrorScreen = errorPresenter
                        .createNetworkConnectionError(analyticsService: analyticsCenter.analyticsService) { [unowned self] in
                            introViewController?.enableIntroButton()
                            root.popViewController(animated: true)
                            if networkMonitor.isConnected {
                                launchAuthenticationCoordinator()
                            }
                        }
                    root.pushViewController(networkErrorScreen, animated: true)
                }
            }
        
        root.setViewControllers([rootViewController], animated: true)
        if let tokenReadError {
            let unableToLoginErrorScreen = ErrorPresenter
                .createUnableToLoginError(errorDescription: tokenReadError.localizedDescription,
                                          analyticsService: analyticsCenter.analyticsService) { [unowned self] in
                    root.popViewController(animated: true)
                }
            root.pushViewController(unableToLoginErrorScreen, animated: true)
        }
        introViewController = rootViewController
        launchOnboardingCoordinator()
    }
    
    func launchOnboardingCoordinator() {
        if userStore.shouldPromptForAnalytics {
            userStore.shouldPromptForAnalytics = false
            openChildModally(OnboardingCoordinator(analyticsPreferenceStore: analyticsCenter.analyticsPreferenceStore,
                                                   urlOpener: UIApplication.shared))
        }
    }
    
    func launchAuthenticationCoordinator() {
        let ac = AuthenticationCoordinator(root: root,
                                           session: AppAuthSession(window: windowManager.appWindow),
                                           analyticsService: analyticsCenter.analyticsService,
                                           tokenHolder: tokenHolder)
        openChildInline(ac)
        authCoordinator = ac
    }
    
    func handleUniversalLink(_ url: URL) {
        authCoordinator?.handleUniversalLink(url)
    }
    
    func launchEnrolmentCoordinator(localAuth: LAContexting) {
        openChildInline(EnrolmentCoordinator(root: root,
                                             analyticsService: analyticsCenter.analyticsService,
                                             userStore: userStore,
                                             localAuth: localAuth,
                                             tokenHolder: tokenHolder))
    }
}

extension LoginCoordinator: ParentCoordinator {
    func didRegainFocus(fromChild child: ChildCoordinator?) {
        switch child {
        case _ as OnboardingCoordinator:
            return
        case let child as AuthenticationCoordinator where child.loginError != nil:
            introViewController?.enableIntroButton()
            return
        case let child as AuthenticationCoordinator where child.loginError == nil:
            launchEnrolmentCoordinator(localAuth: LAContext())
        case _ as EnrolmentCoordinator:
            root.dismiss(animated: true)
            finish()
        default:
            break
        }
    }
}
