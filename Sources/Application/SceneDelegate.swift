import Authentication
import GAnalytics
import GDSCommon
import LocalAuthentication
import Logging
import Networking
import SecureStore
import UIKit

final class SceneDelegate: UIResponder,
                           UIWindowSceneDelegate,
                           SceneLifecycle {

    private var rootCoordinator: QualifyingCoordinator?

    let analyticsService: AnalyticsService = GAnalytics()
    private lazy var networkClient = NetworkClient()
    private lazy var sessionManager = {
        let manager = PersistentSessionManager()
        networkClient.authorizationProvider = manager.tokenProvider
        return manager
    }()

    private lazy var analyticsCenter = {
        AnalyticsCenter(analyticsService: self.analyticsService,
                        analyticsPreferenceStore: UserDefaultsPreferenceStore())
    }()

    private lazy var appQualifyingService = {
        AppQualifyingService(sessionManager: self.sessionManager)
    }()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            fatalError("Window failed to initialise in SceneDelegate")
        }
        // TODO: DCMAW-9866 | can we move this into the UI (viewDidAppear?) itself
        trackSplashScreen()

        rootCoordinator = QualifyingCoordinator(
            window: UIWindow(windowScene: windowScene),
            analyticsCenter: analyticsCenter,
            appQualifyingService: appQualifyingService,
            sessionManager: sessionManager,
            networkClient: networkClient
        )
        rootCoordinator?.start()

        setUpBasicUI()
    }
    
    func scene(_ scene: UIScene,
               continue userActivity: NSUserActivity) {
        guard let incomingURL = userActivity.webpageURL else { return }
        rootCoordinator?.handleUniversalLink(incomingURL)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // TODO: DCMAW-9866 | why are we starting this when moving to the background???
        rootCoordinator?.start()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // TODO: DCMAW-9866 | do we need to call app info here too?
    }
    
    private func setUpBasicUI() {
        UITabBar.appearance().tintColor = .gdsGreen
        UITabBar.appearance().backgroundColor = .systemBackground
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .gdsGreen
    }
}
