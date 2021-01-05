//
//  LoadNextUsersPageUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine


public class LoadNextUsersPageUseCase: UseCase {
    public typealias Result = AnyPublisher<Void, APIError.User>

    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    public func execute(onStart: (() -> Void)?) -> AnyPublisher<Void, APIError.User> {
        repository.getMore().inject(beforeStart: onStart)
    }
}
