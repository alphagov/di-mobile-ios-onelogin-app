import Authentication
import GDSCommon
import Logging
import UIKit

struct OneLoginIntroViewModel: IntroViewModel {
    var image: UIImage = UIImage(named: "badge") ?? UIImage()
    var title: GDSLocalisedString = "GOV.UK One Login"
    var body: GDSLocalisedString = "Sign in with the email address you use for your GOV.UK One Login."
    var introButtonViewModel: ButtonViewModel
    
    init(analyticsService: AnalyticsService, signinAction: @escaping () -> Void) {
        introButtonViewModel = AnalyticsButtonViewModel(titleKey: "Sign in",
                                                        analyticsService: analyticsService,
                                                        action: {
            signinAction()
        })
    }
    
    func didAppear() { }
}
