import Coordination
import GDSCommon
import Logging
import Networking
import UIKit

@MainActor
final class HomeCoordinator: NSObject,
                             AnyCoordinator,
                             ChildCoordinator,
                             NavigationCoordinator {
    let root = UINavigationController()
    weak var parentCoordinator: ParentCoordinator?
    private let analyticsService: AnalyticsService
    private let networkClient: NetworkClient
    
    init(analyticsService: AnalyticsService,
         networkClient: NetworkClient) {
        self.analyticsService = analyticsService
        self.networkClient = networkClient
    }
    
    func start() {
        root.tabBarItem = UITabBarItem(title: GDSLocalisedString(stringLiteral: "app_homeTitle").value,
                                       image: UIImage(systemName: "house"),
                                       tag: 0)
        let hc = HomeViewController(analyticsService: analyticsService,
                                    networkClient: networkClient)
        root.setViewControllers([hc], animated: true)
    }
}
