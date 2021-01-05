//
//  PersistentUserSessionRepository.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

class PersistentUserSessionRepository {
    
    private let service: AuthenticationService
    private let dataStore: UserSessionDataStore
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: AuthenticationService, dataStore: UserSessionDataStore) {
        self.service = service
        self.dataStore = dataStore
    }
}

extension PersistentUserSessionRepository: UserSessionRepository {
    
    func login(username: String, password: String) -> AnyPublisher<UserSession, LoginError> {
       
        Deferred {
            Future<UserSession, LoginError> { [weak self] promise in
                guard let strongSelf = self else { return }

                strongSelf.service.login(username: username, password: password)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            promise(Result.failure(error))
                        }
                    }, receiveValue: { session in
                        guard let strongSelf = self else { return }
                        
                        strongSelf.dataStore.save(userSession: session)
                            .sink(receiveCompletion: { completion in
                                    if case .failure(_) = completion {
                                        promise(Result.failure(LoginError.notFound))
                                    }
                            }, receiveValue: {session in
                                promise(Result.success(session))
                            })
                            .store(in: &strongSelf.subscriptions)
                    })
                    .store(in: &strongSelf.subscriptions)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, SessionError> {
        
        getCurrentSession()
            .flatMap{
                self.dataStore.delete(userSession: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func getCurrentSession() -> AnyPublisher<UserSession, SessionError> {
        dataStore.read()
    }
}
