//
//  CheckLoginStatusUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 8/01/21.
//

import Combine

public class CheckLoginStatusUseCase: UseCase {
    public typealias Result = AnyPublisher<UserSession, SessionError>
    
    private let repository: CurrentSessionRepository
    
    init(repository: CurrentSessionRepository) {
        self.repository = repository
    }
    
    public func execute(onStart: (() -> Void)?) -> AnyPublisher<UserSession, SessionError> {
        repository.getCurrentSession()
    }
}
