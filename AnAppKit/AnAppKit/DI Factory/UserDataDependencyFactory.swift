//
//  UserDataDependencyFactory.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 21/12/20.
//

import Foundation

public class UserDataDependencyFactory {
    
    public init(){}
    
    public func makeRepository() -> UserRepository {
        #if TEST || TEST_UI
        
        return MockUserRepository()
        
        #else
        
        return PersistentUserRepository(service: makeService(), dataStore: makeDataStore())

        #endif
    }
    
    private func makeService() -> UserService {
        UserRestfulService()
    }
    
    private func makeDataStore() -> UserDataStore {
        RealmUserDataStore()
    }
}
