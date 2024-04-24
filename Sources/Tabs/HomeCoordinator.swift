import Coordination
import UIKit

final class HomeCoordinator: NSObject,
                             AnyCoordinator,
                             ChildCoordinator,
                             NavigationCoordinator {
    var parentCoordinator: ParentCoordinator?
    var root = UINavigationController()
    private var accessToken: String?
    private var baseVc: TokensViewController!

    func start() {
        baseVc = TokensViewController(TokensViewModel {
            self.showDeveloperMenu()
        })
        root.setViewControllers([baseVc], animated: true)
    }
    
    func updateToken(accessToken: String?) {
        baseVc.updateToken(accessToken: accessToken)
    }
    
    func showDeveloperMenu() {
        let navController = UINavigationController()
        let developerMenuVC = DeveloperMenuViewController()
        navController.setViewControllers([developerMenuVC], animated: true)
        root.present(navController, animated: true)
    }
}
