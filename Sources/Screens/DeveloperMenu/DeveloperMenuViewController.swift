import GDSCommon
import Networking
import UIKit

final class DeveloperMenuViewController: BaseViewController {
    override var nibName: String? { "DeveloperMenu" }
    
    weak var parentCoordinator: HomeCoordinator?
    let viewModel: DeveloperMenuViewModel
    let sessionManager: SessionManager
    let networkClient: NetworkClient

    private let defaultsStore: DefaultsStorable

    init(parentCoordinator: HomeCoordinator,
         viewModel: DeveloperMenuViewModel,
         sessionManager: SessionManager,
         networkClient: NetworkClient,
         defaultsStore: DefaultsStorable = UserDefaults.standard) {
        self.parentCoordinator = parentCoordinator
        self.viewModel = viewModel
        self.sessionManager = sessionManager
        self.networkClient = networkClient
        self.defaultsStore = defaultsStore
        super.init(viewModel: viewModel,
                   nibName: "DeveloperMenu",
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet private var happyPathButton: RoundedButton! {
        didSet {
            if AppEnvironment.callingSTSEnabled {
                happyPathButton.titleLabel?.adjustsFontForContentSizeCategory = true
                happyPathButton.setTitle("Hello World Happy", for: .normal)
            } else {
                happyPathButton.isHidden = true
            }
            happyPathButton.accessibilityIdentifier = "sts-happy-path-button"
        }
    }
    
    @IBAction private func happyPathButtonAction(_ sender: Any) {
        happyPathButton.isLoading = true
        helloWorldHappyPath()
    }
    
    // Makes a successful request to the hello-world endpoint as long as the access token is valid
    private func helloWorldHappyPath() {
        guard sessionManager.isSessionValid else {
            parentCoordinator?.accessTokenInvalidAction()
            return
        }

        Task {
            do {
                let data = try await networkClient.makeAuthorizedRequest(exchangeRequest: URLRequest(url: AppEnvironment.stsToken),
                                                                         scope: "sts-test.hello-world.read",
                                                                         request: URLRequest(url: AppEnvironment.stsHelloWorld))
                happyPathResultLabel.showSuccessMessage("Success: \(String(decoding: data, as: UTF8.self))")
            } catch let error as ServerError {
                happyPathResultLabel.showErrorMessage(error)
            } catch {
                happyPathResultLabel.showErrorMessage()
            }
            happyPathButton.isLoading = false
        }
    }
    
    @IBOutlet private var happyPathResultLabel: UILabel! {
        didSet {
            happyPathResultLabel.font = .bodyBold
            happyPathResultLabel.isHidden = true
            happyPathResultLabel.accessibilityIdentifier = "sts-happy-path-result"
        }
    }
    
    @IBOutlet private var errorPathButton: RoundedButton! {
        didSet {
            if AppEnvironment.callingSTSEnabled {
                errorPathButton.titleLabel?.adjustsFontForContentSizeCategory = true
                errorPathButton.setTitle("Hello World Error", for: .normal)
            } else {
                errorPathButton.isHidden = true
            }
            errorPathButton.accessibilityIdentifier = "sts-error-path-button"
        }
    }
    
    @IBAction private func errorPathButtonAction(_ sender: Any) {
        errorPathButton.isLoading = true
        helloWorldErrorPath()
    }
    
    // Makes an unsuccessful request to the hello-world endpoint, the scope is invalid for this so a 400 response is returned
    private func helloWorldErrorPath() {
        guard sessionManager.isSessionValid else {
            parentCoordinator?.accessTokenInvalidAction()
            return
        }

        Task {
            do {
                _ = try await networkClient.makeAuthorizedRequest(exchangeRequest: URLRequest(url: AppEnvironment.stsToken),
                                                                  scope: "sts-test.hello-world",
                                                                  request: URLRequest(url: AppEnvironment.stsHelloWorld))
            } catch let error as ServerError {
                errorPathResultLabel.showErrorMessage(error)
            } catch {
                errorPathResultLabel.showErrorMessage()
            }
            errorPathButton.isLoading = false
        }
    }
    
    @IBOutlet private var errorPathResultLabel: UILabel! {
        didSet {
            errorPathResultLabel.isHidden = true
            errorPathResultLabel.accessibilityIdentifier = "sts-error-path-result"
            errorPathResultLabel.font = .bodyBold
        }
    }
    
    @IBOutlet private var unauthorizedPathButton: RoundedButton! {
        didSet {
            if AppEnvironment.callingSTSEnabled {
                unauthorizedPathButton.titleLabel?.adjustsFontForContentSizeCategory = true
                unauthorizedPathButton.setTitle("Hello World Unauthorized", for: .normal)
            } else {
                unauthorizedPathButton.isHidden = true
            }
            unauthorizedPathButton.accessibilityIdentifier = "sts-unauthorized-path-button"
        }
    }
    
    @IBAction private func unauthorizedPathButtonAction(_ sender: Any) {
        unauthorizedPathButton.isLoading = true
        helloWorldUnauthorizedPath()
    }
    
    // Makes an unsuccessful request to the hello-world endpoint, the endpoint returns a 401 unauthorized response
    private func helloWorldUnauthorizedPath() {
        guard sessionManager.isSessionValid else {
            parentCoordinator?.accessTokenInvalidAction()
            return
        }
        
        Task {
            do {
                _ = try await networkClient.makeAuthorizedRequest(exchangeRequest: URLRequest(url: AppEnvironment.stsToken),
                                                                  scope: "sts-test.hello-world.read",
                                                                  request: URLRequest(url: AppEnvironment.stsHelloWorldError))
            } catch let error as ServerError {
                unauthorizedPathResultLabel.showErrorMessage(error)
            } catch {
                unauthorizedPathResultLabel.showErrorMessage()
            }
            unauthorizedPathButton.isLoading = false
        }
    }
    
    @IBOutlet private var unauthorizedPathResultLabel: UILabel! {
        didSet {
            unauthorizedPathResultLabel.isHidden = true
            unauthorizedPathResultLabel.accessibilityIdentifier = "sts-unauthorized-path-result"
            unauthorizedPathResultLabel.font = .bodyBold
        }
    }
    
    @IBOutlet private var deletePersistentSessionIDButton: RoundedButton! {
        didSet {
            if AppEnvironment.callingSTSEnabled {
                deletePersistentSessionIDButton.titleLabel?.adjustsFontForContentSizeCategory = true
                deletePersistentSessionIDButton.setTitle("Delete Persistent Session ID", for: .normal)
            } else {
                deletePersistentSessionIDButton.isHidden = true
            }
            deletePersistentSessionIDButton.accessibilityIdentifier = "sts-delete-persistent-session-id-path-button"
        }
    }
    
    @IBAction private func deletePersistentSessionIDAction(_ sender: Any) {
        sessionManager.clearAllSessionData()
        deletePersistentSessionIDButton.backgroundColor = .gdsBrightPurple
    }
    
    @IBOutlet private var expireAccessTokenButton: RoundedButton! {
        didSet {
            if AppEnvironment.callingSTSEnabled {
                expireAccessTokenButton.titleLabel?.adjustsFontForContentSizeCategory = true
                expireAccessTokenButton.setTitle("Expire Access Token", for: .normal)
            } else {
                expireAccessTokenButton.isHidden = true
            }
            expireAccessTokenButton.accessibilityIdentifier = "sts-expire-access-token-button"
        }
    }
    
    @IBAction private func expireAccessTokenAction(_ sender: Any) {
        defaultsStore.set(Date.distantPast, forKey: .accessTokenExpiry)
        expireAccessTokenButton.backgroundColor = .gdsBrightPurple
    }
}

fileprivate extension UILabel {
    func showErrorMessage(_ error: ServerError? = nil) {
        textColor = .red
        isHidden = false
        if let error {
            text = "Error code: \(error.errorCode)\nEndpoint: \(error.endpoint ?? "missing")"
        } else {
            text = "Error"
        }
    }
    
    func showSuccessMessage(_ message: String) {
        textColor = .gdsGreen
        isHidden = false
        text = message
    }
}
