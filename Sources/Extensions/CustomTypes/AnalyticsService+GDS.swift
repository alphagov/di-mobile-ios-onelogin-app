import GDSAnalytics
import Logging

typealias ScreenType = Logging.ScreenType & GDSAnalytics.ScreenType

enum AppTaxonomy: String {
    case home
    case wallet
    case profile
}

extension AnalyticsService {
    public func logEvent(_ event: Event) {
        logEvent(event.name,
                 parameters: event.parameters)
    }
    
    public func trackScreen<Screen>(_ screen: Screen)
    where Screen: ScreenViewProtocol & LoggableScreenV2 {
        trackScreen(screen,
                    parameters: screen.parameters)
    }
    
    mutating func setAdditionalParameters(appTaxonomy: AppTaxonomy) {
        additionalParameters = additionalParameters.merging([
            "taxonomy_level2": appTaxonomy.rawValue,
            "taxonomy_level3": appTaxonomy.rawValue == "profile" ? "my profile" : "undefined"
        ]) { $1 }
    }
    
    mutating func resetAdditionalParameters() {
        additionalParameters = additionalParameters.merging([
            "taxonomy_level2": "login",
            "taxonomy_level3": "undefined"
        ]) { $1 }
    }
}

extension EventName: LoggableEvent { }

extension ScreenView: LoggableScreenV2
where Screen: Logging.ScreenType {
    public var name: String {
        title
    }
    
    public var type: Logging.ScreenType {
        self.screen
    }
}

extension ErrorScreenView: LoggableScreenV2
where Screen: Logging.ScreenType {
    public var name: String {
        title
    }

    public var type: Logging.ScreenType {
        self.screen
    }
}
