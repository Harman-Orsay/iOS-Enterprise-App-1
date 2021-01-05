//
//  MockAuthenticationService.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Combine

class MockAuthenticationService: AuthenticationService {
    
    func login(username: String, password: String) -> AnyPublisher<UserSession, LoginError> {
        Just(UserSession(profile: UserProfile(name: "Dummy user with username: " + username,
                                              email: "dummyemail@someserver.com",
                                              mobileNumber: "1234567890"),
                         remoteSession: RemoteUserSession(token: "hdvuoeuvubewubvuiewvbubub",
                                                          createdOn: Date())))
            .mapError{_ in LoginError.notFound}
            .eraseToAnyPublisher()
    }

}
