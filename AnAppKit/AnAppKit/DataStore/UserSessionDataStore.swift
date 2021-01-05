//
//  UserSessionDataStore.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

protocol UserSessionDataStore {
    func read() -> AnyPublisher<UserSession, SessionError>
    func save(userSession: UserSession) -> AnyPublisher<UserSession, SessionError>
    func delete(userSession: UserSession) -> AnyPublisher<Void, SessionError>
}
