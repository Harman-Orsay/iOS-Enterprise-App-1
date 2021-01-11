//
//  UserSessionDependencyFactory.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Foundation

public protocol UserSessionDependencyFactory {
    func makeUserSessionUseCaseFactory() -> UserSessionUseCaseFactory
    func makeRepository() -> UserSessionRepository
}

class UserSessionDependencyFactoryFactory: UserSessionDependencyFactory {
    
    public init(){}
    
    public func makeUserSessionUseCaseFactory() -> UserSessionUseCaseFactory {
        UserSessionUseCaseContainer(repository: makeRepository())
    }
    
    public func makeRepository() -> UserSessionRepository {
        return PersistentUserSessionRepository(service: makeService(), dataStore: makeDataStore())
    }
    
    private func makeService() -> AuthenticationService {
        MockAuthenticationService()
    }
    
    private func makeDataStore() -> UserSessionDataStore {
        KeychainUserSessionDataStore()
    }
}
