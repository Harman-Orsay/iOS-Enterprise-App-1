//
//  DeleteUserUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

public class DeleteUserUseCase: UseCase {
    public typealias Result = AnyPublisher<Void, APIError.User>
    
    private let repository: UserRepository
    private let user: User
    
    init(repository: UserRepository, user: User) {
        self.repository = repository
        self.user = user
    }

    public func execute(onStart: (() -> Void)?) -> AnyPublisher<Void, APIError.User> {
        repository.delete(user: user).inject(beforeStart: onStart)
    }
}


