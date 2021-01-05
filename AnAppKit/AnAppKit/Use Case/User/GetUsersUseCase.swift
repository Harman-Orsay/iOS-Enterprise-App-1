//
//  GetUsersUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

public class GetUsersUseCase: UseCase {
    public typealias Result = AnyPublisher<[User], Never>
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }

    public func execute(onStart: (() -> Void)?) -> AnyPublisher<[User], Never> {
        repository.users.inject(beforeStart: onStart)
    }
}
