//
//  UserSessionRepository.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

public protocol UserSessionRepository {
    
    func login(username: String, password: String) -> AnyPublisher<UserSession, LoginError>
    func logout() -> AnyPublisher<Void, SessionError>
    func getCurrentSession() -> AnyPublisher<UserSession, SessionError>
}
