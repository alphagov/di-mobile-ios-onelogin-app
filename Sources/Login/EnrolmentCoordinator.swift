import Coordination
import GDSCommon
import LocalAuthentication
import Logging
import UIKit

final class EnrolmentCoordinator: NSObject,
                                  ChildCoordinator,
                                  NavigationCoordinator {
    let root: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    private let analyticsService: AnalyticsService
    private let sessionManager: SessionManager
    
    init(root: UINavigationController,
         analyticsService: AnalyticsService,
         sessionManager: SessionManager) {
        self.root = root
        self.analyticsService = analyticsService
        self.sessionManager = sessionManager
    }
    
    func start() {
        switch sessionManager.localAuthentication.type {
        case .touchID:
            let viewModel = TouchIDEnrolmentViewModel(analyticsService: analyticsService) { [unowned self] in
                saveSession()
            } secondaryButtonAction: { [unowned self] in
                completeEnrolment()
            }
            let touchIDEnrolmentScreen = GDSInformationViewController(viewModel: viewModel)
            root.pushViewController(touchIDEnrolmentScreen, animated: true)
        case .faceID:
            let viewModel = FaceIDEnrolmentViewModel(analyticsService: analyticsService) { [unowned self] in
                saveSession()
            } secondaryButtonAction: { [unowned self] in
                completeEnrolment()
            }
            let faceIDEnrolmentScreen = GDSInformationViewController(viewModel: viewModel)
            root.pushViewController(faceIDEnrolmentScreen, animated: true)
        case .passcodeOnly:
            saveSession()
        case .none:
            showPasscodeInfo()
        }
    }
    
    private func saveSession() {
        Task {
#if targetEnvironment(simulator)
            if sessionManager is PersistentSessionManager {
                completeEnrolment()
                return
            }
#endif
            try await sessionManager.saveSession()
            completeEnrolment()
        }
    }

    private func completeEnrolment() {
        NotificationCenter.default.post(name: .enrolmentComplete)
        finish()
    }

    private func showPasscodeInfo() {
        let viewModel = PasscodeInformationViewModel(analyticsService: analyticsService) { [unowned self] in
                completeEnrolment()
            }
        let passcodeInformationScreen = GDSInformationViewController(viewModel: viewModel)
        root.pushViewController(passcodeInformationScreen, animated: true)
    }
}
