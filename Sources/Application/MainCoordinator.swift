import Coordination
import GDSAnalytics
import Networking
import SecureStore
import UIKit

final class MainCoordinator: NSObject,
                             AnyCoordinator,
                             TabCoordinator {
    let windowManager: WindowManagement
    let root: UITabBarController
    let analyticsCenter: AnalyticsCentral
    var childCoordinators = [ChildCoordinator]()
    let userStore: UserStorable
    let tokenHolder = TokenHolder()
    var networkClient: NetworkClient?
    private weak var loginCoordinator: LoginCoordinator?
    private weak var homeCoordinator: HomeCoordinator?
    private weak var profileCoordinator: ProfileCoordinator?
    
    init(windowManager: WindowManagement,
         root: UITabBarController,
         analyticsCenter: AnalyticsCentral,
         userStore: UserStorable) {
        self.windowManager = windowManager
        self.root = root
        self.analyticsCenter = analyticsCenter
        self.userStore = userStore
    }
    
    func start() {
        root.tabBar.backgroundColor = .systemBackground
        root.tabBar.tintColor = .gdsGreen
        root.delegate = self
        addTabs()
        showLogin()
    }
    
    func handleUniversalLink(_ url: URL) {
        loginCoordinator?.handleUniversalLink(url)
    }
    
    func evaluateRevisit(action: @escaping () -> Void) {
        Task {
            await MainActor.run {
                if userStore.returningAuthenticatedUser {
                    do {
                        tokenHolder.accessToken = try userStore.secureStoreService.readItem(itemName: .accessToken)
                        homeCoordinator?.updateToken(accessToken: tokenHolder.accessToken)
                        action()
                    } catch {
                        print("Error getting token: \(error)")
                    }
                } else if tokenHolder.validAccessToken || tokenHolder.accessToken == nil {
                    action()
                } else {
                    tokenHolder.accessToken = nil
                    showLogin()
                    action()
                }
            }
        }
    }
    
    private func showLogin() {
        let lc = LoginCoordinator(windowManager: windowManager,
                                  root: UINavigationController(),
                                  analyticsCenter: analyticsCenter,
                                  networkMonitor: NetworkMonitor.shared,
                                  userStore: userStore,
                                  tokenHolder: tokenHolder)
        openChildModally(lc, animated: false)
        loginCoordinator = lc
    }
}

extension MainCoordinator {
    private func addTabs() {
        addHomeTab()
        addWalletTab()
        addProfileTab()
    }
    
    private func addHomeTab() {
        let hc = HomeCoordinator(analyticsService: analyticsCenter.analyticsService)
        addTab(hc)
        homeCoordinator = hc
    }
    
    private func addWalletTab() {
        let wc = WalletCoordinator()
        addTab(wc)
    }
    
    private func addProfileTab() {
        let pc = ProfileCoordinator(analyticsService: analyticsCenter.analyticsService,
                                    urlOpener: UIApplication.shared)
        addTab(pc)
        profileCoordinator = pc
    }
}

extension MainCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        var event: IconEvent? {
            switch viewController.tabBarItem.tag {
            case 0:
                .init(textKey: "home")
            case 1:
                .init(textKey: "wallet")
            case 2:
                .init(textKey: "profile")
            default:
                nil
            }
        }
        if let event {
            analyticsCenter.analyticsService.logEvent(event)
        }
    }
}

extension MainCoordinator: ParentCoordinator {
    func didRegainFocus(fromChild child: ChildCoordinator?) {
        switch child {
        case _ as LoginCoordinator:
            homeCoordinator?.updateToken(accessToken: tokenHolder.accessToken)
            profileCoordinator?.updateToken(accessToken: tokenHolder.accessToken)
            networkClient = NetworkClient(authenticationProvider: tokenHolder)
            homeCoordinator?.networkClient = networkClient
        default:
            break
        }
    }
}
