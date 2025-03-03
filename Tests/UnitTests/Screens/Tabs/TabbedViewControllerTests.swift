import GDSAnalytics
import GDSCommon
import Networking
@testable import OneLogin
import XCTest

@MainActor
final class TabbedViewControllerTests: XCTestCase {
    private var mockAnalyticsService: MockAnalyticsService!
    private var mockAnalyticsPreference: MockAnalyticsPreferenceStore!
    private var mockSessionManager: MockSessionManager!
    private var viewModel: TabbedViewModel!
    private var sut: TabbedViewController!

    private var didTapRow = false
    private var didAppearCalled = false

    override func setUp() {
        super.setUp()

        mockAnalyticsService = MockAnalyticsService()
        mockAnalyticsPreference = MockAnalyticsPreferenceStore()
        mockSessionManager = MockSessionManager()
        viewModel = MockTabbedViewModel(analyticsService: mockAnalyticsService,
                                        navigationTitle: "Test Navigation Title",
                                        sectionModels: createSectionModels()) {
            self.didAppearCalled = true
        }
        sut = TabbedViewController(viewModel: viewModel,
                                   userProvider: mockSessionManager,
                                   analyticsPreference: mockAnalyticsPreference)
    }
    
    override func tearDown() {
        mockAnalyticsService = nil
        mockSessionManager = nil
        viewModel = nil
        sut = nil
        
        didTapRow = false
        didAppearCalled = false
        
        super.tearDown()
    }
}

extension TabbedViewControllerTests {
    func test_numberOfSections() {
        XCTAssertEqual(sut.numberOfSections(in: try sut.tabbedTableView), 1)
    }
    
    func test_numberOfRows() {
        XCTAssertEqual(sut.tableView(try sut.tabbedTableView, numberOfRowsInSection: 0), 1)
    }
    
    func test_rowSelected() throws {
        XCTAssertFalse(didTapRow)
        let indexPath = IndexPath(row: 0, section: 0)
        try sut.tabbedTableView.reloadData()
        sut.tableView(try XCTUnwrap(sut.tabbedTableView), didSelectRowAt: indexPath)
        XCTAssertTrue(didTapRow)
    }
    
    func test_headerConfiguration() throws {
        let header = sut.tableView(try sut.tabbedTableView, viewForHeaderInSection: 0) as? UITableViewHeaderFooterView
        let headerLabel = try XCTUnwrap(header?.textLabel)
        XCTAssertEqual(headerLabel.text, "Test Header")
        XCTAssertEqual(headerLabel.font, .bodyBold)
        XCTAssertEqual(headerLabel.textColor, .label)
        XCTAssertTrue(headerLabel.adjustsFontForContentSizeCategory)
    }
    
    func test_cellConfiguration() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(try sut.tabbedTableView, cellForRowAt: indexPath)
        let cellConfig = try XCTUnwrap(cell.contentConfiguration as? UIListContentConfiguration)
        XCTAssertEqual(cellConfig.text, "Test Cell")
        XCTAssertEqual(cellConfig.textProperties.color, .systemRed)
        XCTAssertEqual(cellConfig.secondaryText, "test@example.com")
        XCTAssertEqual(cellConfig.secondaryTextProperties.color, .gdsGrey)
        XCTAssertEqual(cellConfig.image, UIImage(named: "userAccountIcon"))
        XCTAssertTrue((cell.accessoryView as? UIImageView)?.image != nil)
        XCTAssertEqual(cell.accessoryView?.tintColor, .secondaryLabel)
    }
    
    func test_footerConfiguration() throws {
        let header = sut.tableView(try sut.tabbedTableView, viewForFooterInSection: 0) as? UITableViewHeaderFooterView
        let headerLabel = try XCTUnwrap(header?.textLabel)
        XCTAssertEqual(headerLabel.text, "Test Footer")
        XCTAssertEqual(headerLabel.numberOfLines, 0)
        XCTAssertEqual(headerLabel.lineBreakMode, .byWordWrapping)
        XCTAssertEqual(headerLabel.font, .footnote)
        XCTAssertEqual(headerLabel.textColor, .secondaryLabel)
        XCTAssertTrue(headerLabel.adjustsFontForContentSizeCategory)
    }

    @MainActor
    func test_updateUser() {
        let viewModel = SettingsTabViewModel(analyticsService: mockAnalyticsService,
                                             userProvider: mockSessionManager,
                                             openSignOutPage: { },
                                             openDeveloperMenu: { })
        sut = TabbedViewController(viewModel: viewModel,
                                   userProvider: mockSessionManager,
                                   analyticsPreference: mockAnalyticsPreference)
        // GIVEN I am not logged in
        XCTAssertEqual(viewModel.sectionModels[0].tabModels[0].cellSubtitle, "")
        // WHEN the user is updated
        mockSessionManager.user.send(MockUser())
        // THEN my email is displayed
        XCTAssertEqual(viewModel.sectionModels[0].tabModels[0].cellSubtitle, "test@example.com")
    }
    
    func test_updateAnalytics() throws {
        mockAnalyticsPreference.hasAcceptedAnalytics = true
        XCTAssertTrue(try sut.analyticsSwitch.isOn)
        
        try sut.analyticsSwitch.sendActions(for: .valueChanged)
        
        XCTAssertEqual(mockAnalyticsPreference.hasAcceptedAnalytics, false)
    }

    func test_screenAnalytics() {
        sut.screenAnalytics()
        XCTAssertTrue(didAppearCalled)
    }
    
    private func createSectionModels() -> [TabbedViewSectionModel] {
        let testSection = TabbedViewSectionModel(sectionTitle: "Test Header",
                                                 sectionFooter: "Test Footer",
                                                 tabModels: [.init(cellTitle: "Test Cell",
                                                                   cellSubtitle: MockUser().email,
                                                                   image: UIImage(named: "userAccountIcon"),
                                                                   accessoryView: "arrow.up.right",
                                                                   textColor: .systemRed) {
            self.didTapRow = true
        }])
        
        return [testSection]
    }
}

extension TabbedViewController {
    var tabbedTableView: UITableView {
        get throws {
            try XCTUnwrap(view[child: "tabbed-view-table-view"])
        }
    }
    
    var analyticsSwitch: UISwitch {
        get throws {
            try XCTUnwrap(view[child: "tabbed-view-analytics-switch"])
        }
    }
}
