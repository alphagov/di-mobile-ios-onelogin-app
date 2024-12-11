import Foundation

enum AttestationStorageKey: String {
    case attestationJWT
    case attestationExpiry
}

enum AttestationStorageError: Error {
    case cantRetrieveAttestationJWT
    case cantRetrieveExpiryDate
}

extension UserDefaults: AttestationStorage {
    public var validAttestation: Bool? {
        guard let expiry = value(
            forKey: AttestationStorageKey.attestationExpiry.rawValue
        ) as? Date else {
            return nil
        }
        return Date() < expiry
    }
    
    public var attestationJWT: String {
        get throws {
            guard let attestation = value(
                forKey: AttestationStorageKey.attestationJWT.rawValue
            ) as? String else {
                throw AttestationStorageError.cantRetrieveAttestationJWT
            }
            return attestation
        }
    }
    
    public func store(assertionJWT: String, assertionExpiry: Date) {
        set(
            assertionJWT,
            forKey: AttestationStorageKey.attestationJWT.rawValue
        )
        set(
            assertionExpiry,
            forKey: AttestationStorageKey.attestationExpiry.rawValue
        )
    }
}
