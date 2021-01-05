//
//  UserSessionDependencyFactory.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Foundation

public class UserSessionDependencyFactory {
    
    public init(){}
    
    public func makeRepository() -> UserSessionRepository {
        #if TEST || TEST_UI
        
        return MockUserRepository()
        
        #else
        
        return PersistentUserSessionRepository(service: makeService(), dataStore: makeDataStore())

        #endif
    }
    
    private func makeService() -> AuthenticationService {
        MockAuthenticationService()
    }
    
    private func makeDataStore() -> UserSessionDataStore {
        KeychainUserSessionDataStore()
    }
}
