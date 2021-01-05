//
//  UserDataDependencyFactory.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 21/12/20.
//

import Foundation

public protocol UserDataDependencyFactory {
    func makeUseCaseFactory() -> UserUseCaseFactory
    func makeRepository() -> UserRepository
}

 class UserDataDependencyFactoryFactory: UserDataDependencyFactory {
    
    public init(){}
    
    public func makeUseCaseFactory() -> UserUseCaseFactory {
        UserUseCaseFactoryContainer(repository: makeRepository())
    }
    
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
