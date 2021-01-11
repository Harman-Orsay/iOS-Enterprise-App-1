//
//  UserSessionDependencyFactory.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Foundation

public protocol UserSessionDependencyFactory {
    func makeUseCaseFactory() -> UserSessionUseCaseFactory
}

class UserSessionDependencyFactoryFactory: UserSessionDependencyFactory {
    
    public init(){}
    
    public func makeUseCaseFactory() -> UserSessionUseCaseFactory {
        UserSessionUseCaseContainer(repository: makeRepository())
    }
    
    private func makeRepository() -> UserSessionRepository {
        return PersistentUserSessionRepository(service: makeService(), dataStore: makeDataStore())
    }
    
    private func makeService() -> AuthenticationService {
        MockAuthenticationService()
    }
    
    private func makeDataStore() -> UserSessionDataStore {
        KeychainUserSessionDataStore()
    }
}
