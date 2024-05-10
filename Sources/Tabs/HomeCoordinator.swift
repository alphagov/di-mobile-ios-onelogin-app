import Coordination
import GDSCommon
import Logging
import UIKit

final class HomeCoordinator: NSObject,
                             AnyCoordinator,
                             ChildCoordinator,
                             NavigationCoordinator {
    var parentCoordinator: ParentCoordinator?
    let root = UINavigationController()
    let analyticsService: AnalyticsService
    var networkClient: RequestAuthorizing?
    private(set) var baseVc: TabbedViewController?
    
    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }
    
    func start() {
        root.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let viewModel = TabbedViewModel(analyticsService: analyticsService,
                                        title: "app_homeTitle",
                                        sectionModels: TabbedViewSectionFactory.homeSections(coordinator: self))
        let hc = TabbedViewController(viewModel: viewModel,
                                      headerView: SignInView(viewModel: SignInViewModel()))
        baseVc = hc
        root.setViewControllers([hc], animated: true)
    }
    
    func updateToken(accessToken: String?) {
        baseVc?.updateToken(accessToken: accessToken)
    }
    
    func showDeveloperMenu() {
        let navController = UINavigationController()
        let devMenuViewModel = DeveloperMenuViewModel()
        let developerMenuVC = DeveloperMenuViewController(viewModel: devMenuViewModel,
                                                          networkClient: networkClient)
        navController.setViewControllers([developerMenuVC], animated: true)
        root.present(navController, animated: true)
    }
}
