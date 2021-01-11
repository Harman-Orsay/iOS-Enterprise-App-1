//
//  UserSessionRepository.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

public protocol UserSessionRepository: CurrentSessionRepository {
    
    func login(username: String, password: String) -> AnyPublisher<UserSession, LoginError>
    func logout() -> AnyPublisher<Void, SessionError>
}

public protocol CurrentSessionRepository {
    func getCurrentSession() -> AnyPublisher<UserSession, SessionError>
}
