//
//  AuthenticationService.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

protocol AuthenticationService {
    func login(username: String, password: String) -> AnyPublisher<UserSession, LoginError>
}
