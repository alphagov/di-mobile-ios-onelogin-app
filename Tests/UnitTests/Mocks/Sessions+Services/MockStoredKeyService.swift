import Foundation
@testable import OneLogin

final class MockStoredKeyService: StoredKeyServicing {
    var mockStoredKeys: StoredKeys?
    var didCallFetchStoredKeys: Bool = false
    var didCallSaveStoredKeys: Bool = false

    func fetchStoredKeys() throws -> StoredKeys {
        didCallFetchStoredKeys = true
//      This is force unwrapped, ensure the value is assigned above before calling `fetchStoreKeys` in tests
        return mockStoredKeys!
    }
    
    func saveStoredKeys(keys: StoredKeys) throws {
        didCallSaveStoredKeys = true
    }
}
