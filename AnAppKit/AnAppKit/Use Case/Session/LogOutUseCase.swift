//
//  LogOutUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

public class LogOutUseCase: UseCase {
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
