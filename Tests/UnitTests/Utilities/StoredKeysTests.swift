import Foundation
@testable import OneLogin
import XCTest

final class StoredKeysTests: XCTestCase {
    private var sut: SecureTokenStore!
    private var accessControlEncryptedStore: MockSecureStoreService!

    override func setUp() {
        super.setUp()
        
        accessControlEncryptedStore = MockSecureStoreService()
        sut = SecureTokenStore(accessControlEncryptedStore: accessControlEncryptedStore)
    }

    override func tearDown() {
        sut = nil
        accessControlEncryptedStore = nil

        super.tearDown()
    }
}

extension StoredKeysTests {
    func test_canFetchStoredKeys() throws {
        let tokensToSave = StoredTokens(idToken: "idToken", accessToken: "accessToken")
        _ = try JSONEncoder().encode(tokensToSave).base64EncodedString()
        try sut.save(tokens: tokensToSave)
        let storedTokens = try sut.fetch()
        XCTAssertEqual(storedTokens.accessToken, tokensToSave.accessToken)
        XCTAssertEqual(storedTokens.idToken, tokensToSave.idToken)
    }

    func test_canSaveKeys() throws {
        let tokens = StoredTokens(idToken: "idToken", accessToken: "accessToken")
        let tokensAsData = try JSONEncoder().encode(tokens).base64EncodedString()
        try sut.save(tokens: tokens)
        XCTAssertEqual(accessControlEncryptedStore.savedItems, [.storedTokens: tokensAsData])
    }

    func test_deletesTokens() throws {
        sut.delete()
        XCTAssertEqual(accessControlEncryptedStore.savedItems, [:])
    }
}
