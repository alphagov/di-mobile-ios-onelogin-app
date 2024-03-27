import Authentication
import GAnalytics
import LocalAuthentication
import Logging
import SecureStore
import UIKit

class SceneDelegate: UIResponder,
                     UIWindowSceneDelegate,
                     SceneLifecycle {
    var windowScene: UIWindowScene?
    var coordinator: MainCoordinator?
    let analyticsService: AnalyticsService = GAnalytics()
    var unlockWindow: UIWindow?
    private var shouldCallSceneWillEnterForeground = false
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            fatalError("Window failed to initialise in SceneDelegate")
        }
        self.windowScene = windowScene
        initialiseMainCoordinator(window: UIWindow(windowScene: windowScene))
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let incomingURL = userActivity.webpageURL else { return }
        coordinator?.handleUniversalLink(incomingURL)
    }
    
    func initialiseMainCoordinator(window: UIWindow) {
        let tabController = UITabBarController()
        let analyticsCentre = AnalyticsCenter(analyticsService: analyticsService,
                                              analyticsPreferenceStore: UserDefaultsPreferenceStore())
        let secureStoreService = SecureStoreService(configuration: .init(id: .oneLoginTokens,
                                                                         accessControlLevel: .currentBiometricsOrPasscode,
                                                                         localAuthStrings: LAContext().contextStrings))
        let userStore = UserStorage(secureStoreService: secureStoreService,
                                    defaultsStore: UserDefaults.standard)
        coordinator = MainCoordinator(window: window,
                                      root: tabController,
                                      analyticsCentre: analyticsCentre,
                                      userStore: userStore)
        window.rootViewController = tabController
        window.makeKeyAndVisible()
        coordinator?.start()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        displayUnlockScreen()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if shouldCallSceneWillEnterForeground {
            promptToUnlock()
        } else {
            shouldCallSceneWillEnterForeground = true
        }
    }
}
