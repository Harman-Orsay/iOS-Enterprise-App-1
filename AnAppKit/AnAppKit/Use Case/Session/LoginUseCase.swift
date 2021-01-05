//
//  LoginUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

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
