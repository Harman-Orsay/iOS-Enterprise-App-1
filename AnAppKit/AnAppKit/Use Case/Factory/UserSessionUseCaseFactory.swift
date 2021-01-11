//
//  UserSessionUseCaseFactory.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

public protocol UserSessionUseCaseFactory {
    func makeLoginUseCase(username: String, password: String) -> LoginUseCase
    func makeLogOutUseCase() -> LogOutUseCase
    func makeCheckLoginStatusUseCase() -> CheckLoginStatusUseCase
}


class UserSessionUseCaseContainer: UserSessionUseCaseFactory {
    
    private let repository: UserSessionRepository
    
    init(repository: UserSessionRepository) {
        self.repository = repository
    }
    
    func makeLoginUseCase(username: String, password: String) -> LoginUseCase {
        LoginUseCase(username: username, password: password, repository: repository)
    }
    
    func makeLogOutUseCase() -> LogOutUseCase {
        LogOutUseCase(repository: repository)
    }
    
    func makeCheckLoginStatusUseCase() -> CheckLoginStatusUseCase {
        CheckLoginStatusUseCase(repository: repository)
    }
}
