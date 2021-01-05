//
//  UseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 1/01/21.
//

import Foundation
import Combine

public protocol UseCase {
    associatedtype Result
    
    func execute(onStart: (() -> Void)?) -> Result
}

typealias CancellableUseCase = UseCase & Cancellable

public enum LoginError: Error{
    case network
    case notFound
}
public enum LogOutError: Error{ //in case logout has an api call
    case network
    case unknown
}

public enum SessionError: Error {
    case expired
    case notFound
}

public enum ErrorX: Error {
    case unknown
}

public class LoginUseCase: UseCase {
    public typealias Result = AnyPublisher<UserSession, LoginError>
    
    private let username: String
    private let password: String
    private let repository: UserSessionRepository
    
    init(username: String, password: String, repository: UserSessionRepository) {
        self.username = username
        self.password = password
        self.repository = repository
    }
    
    public func execute(onStart: (() -> Void)?) -> AnyPublisher<UserSession, LoginError> {
        repository.login(username: username, password: password)
            .inject(beforeStart: onStart)
    }
}


class LogOutUseCase: UseCase {
    public typealias Result = AnyPublisher<Void, LogOutError>

    private let repository: UserSessionRepository
    
    init(repository: UserSessionRepository) {
        self.repository = repository
    }
    
    public func execute(onStart: (() -> Void)?) -> AnyPublisher<Void, LogOutError> {
        repository.logout()
            .inject(beforeStart: onStart)
            .mapError{sessionError -> LogOutError in
                .unknown
            }.eraseToAnyPublisher()
    }
}



class AddUserUseCase: UseCase {
    public typealias Result = AnyPublisher<Void, APIError.User>
    
    private let repository: UserRepository
    private let user: User
    
    init(repository: UserRepository, user: User) {
        self.repository = repository
        self.user = user
    }

    func execute(onStart: (() -> Void)?) -> AnyPublisher<Void, APIError.User> {
        repository.add(user: user).inject(beforeStart: onStart)
    }
}


class DeleteUserUseCase: UseCase {
    public typealias Result = AnyPublisher<Void, APIError.User>
    
    private let repository: UserRepository
    private let user: User
    
    init(repository: UserRepository, user: User) {
        self.repository = repository
        self.user = user
    }

    func execute(onStart: (() -> Void)?) -> AnyPublisher<Void, APIError.User> {
        repository.delete(user: user).inject(beforeStart: onStart)
    }
}


class SortUseCase: UseCase {
    public typealias Result = Void

    private let repository: UserRepository
    private let sortField: User.SortableField

    init(repository: UserRepository, sortField: User.SortableField) {
        self.repository = repository
        self.sortField = sortField
    }
    
    func execute(onStart: (() -> Void)?) -> Void {
        repository.sort(by: sortField)
    }
}


class GetUsersUseCase: UseCase {
    public typealias Result = AnyPublisher<[User], Never>
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(onStart: (() -> Void)?) -> AnyPublisher<[User], Never> {
        repository.users.inject(beforeStart: onStart)
    }
}


class LoadNextUsersPageUseCase: UseCase {
    public typealias Result = AnyPublisher<Void, APIError.User>

    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(onStart: (() -> Void)?) -> AnyPublisher<Void, APIError.User> {
        repository.getMore().inject(beforeStart: onStart)
    }
}
