import Coordination
import GDSAnalytics
import GDSCommon
import Networking
import UIKit
import Wallet

@MainActor
final class WalletCoordinator: NSObject,
                               AnyCoordinator,
                               ChildCoordinator,
                               NavigationCoordinator,
                               TabItemCoordinator {
    private let window: UIWindow
    let root = UINavigationController()
    weak var parentCoordinator: ParentCoordinator?
    private var analyticsCenter: AnalyticsCentral
    private let sessionManager: SessionManager

    private let networkClient: NetworkClient

    init(window: UIWindow,
         analyticsCenter: AnalyticsCentral,
         networkClient: NetworkClient,
         sessionManager: SessionManager) {
        self.window = window
        self.analyticsCenter = analyticsCenter
        self.networkClient = networkClient
        self.sessionManager = sessionManager
    }
    
    func start() {
        root.tabBarItem = UITabBarItem(title: GDSLocalisedString(stringLiteral: "app_walletTitle").value,
                                       image: UIImage(systemName: "wallet.pass"),
                                       tag: 1)
        WalletSDK.start(in: root,
                        networkClient: networkClient,
                        analyticsService: analyticsCenter.analyticsService,
                        localAuthService: DummyLocalAuthService(),
                        credentialIssuer: AppEnvironment.walletCredentialIssuer.absoluteString)
    }
    
    func didBecomeSelected() {
        analyticsCenter.analyticsService.setAdditionalParameters(appTaxonomy: .wallet)
        let event = IconEvent(textKey: "app_walletTitle")
        analyticsCenter.analyticsService.logEvent(event)
    }
    
    func handleUniversalLink(_ url: URL) {
        WalletSDK.deeplink(with: url.absoluteString)
    }
    
    func deleteWalletData() throws {
        #if DEBUG
        if AppEnvironment.clearWalletErrorEnabled {
            throw TokenError.expired
        }
        #endif
        try WalletSDK.deleteData()
    }
}
