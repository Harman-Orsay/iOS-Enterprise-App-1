//
//  UserUseCaseFactory.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

public protocol UserUseCaseFactory {
    
    func makeGetUserUseCase() -> GetUsersUseCase
    func makeLoadNextUsersPageUseCase() -> LoadNextUsersPageUseCase
    func makeDeleteUserUseCase(user: User) -> DeleteUserUseCase
    func makeSortUserUseCase(sortField: User.SortableField) -> SortUsersUseCase
    func makeAddUserUseCase(user: User) -> AddUserUseCase
}

class UserUseCaseFactoryContainer: UserUseCaseFactory {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func makeGetUserUseCase() -> GetUsersUseCase {
        GetUsersUseCase(repository: repository)
    }
    
    func makeLoadNextUsersPageUseCase() -> LoadNextUsersPageUseCase {
        LoadNextUsersPageUseCase(repository: repository)
    }
    
    func makeDeleteUserUseCase(user: User) -> DeleteUserUseCase {
        DeleteUserUseCase(repository: repository, user: user)
    }
    
    func makeSortUserUseCase(sortField: User.SortableField) -> SortUsersUseCase {
        SortUsersUseCase(repository: repository, sortField: sortField)
    }
    
    func makeAddUserUseCase(user: User) -> AddUserUseCase {
        AddUserUseCase(repository: repository, user: user)
    }
}
