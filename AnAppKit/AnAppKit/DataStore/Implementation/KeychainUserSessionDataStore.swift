//
//  KeychainUserSessionDataStore.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

class KeychainUserSessionDataStore: UserSessionDataStore {
    
    private static let label = "User_Session"
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()

    func read() -> AnyPublisher<UserSession, SessionError> {
        Deferred{
            Future { promise in
                DispatchQueue.global(qos: .default).async {
                        do {
                            let data = try Keychain.find(item: .key(label: Self.label))
                            let session = try Self.decoder.decode(UserSession.self, from: data)
                            DispatchQueue.main.async {
                                promise(Result.success(session))
                            }
                        } catch {
                            DispatchQueue.main.async {
                                promise(Result.failure(.notFound))
                            }
                        }
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func save(userSession: UserSession) -> AnyPublisher<UserSession, SessionError> {
        Deferred{
            Future { promise in
                DispatchQueue.global(qos: .default).async {
                    do {
                        let data = try Self.encoder.encode(userSession)
                        do {
                            try Keychain.save(item: .key(label: Self.label), with: data)
                        } catch {
                            try Keychain.update(item: .key(label: Self.label), with: data)
                        }
                        DispatchQueue.main.async {
                            promise(Result.success(userSession))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            promise(Result.failure(.notFound))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(userSession: UserSession) -> AnyPublisher<Void, SessionError> {
        Deferred{
            Future { promise in
                DispatchQueue.global(qos: .default).async {
                    do {
                        try Keychain.delete(item: .key(label: Self.label))
                        
                        DispatchQueue.main.async {
                            promise(Result.success(()))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            promise(Result.failure(.notFound))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
