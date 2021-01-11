//
//  UserSession.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 12/01/21.
//

import Foundation

public typealias AuthToken = String

struct RemoteUserSession: Codable {

    let token: AuthToken
    let createdOn: Date
    
    init(token: AuthToken, createdOn: Date) {
        self.token = token
        self.createdOn = createdOn
    }
}

public struct UserSession: Codable {

  public let profile: UserProfile
    let remoteSession: RemoteUserSession
    var validity: TimeInterval {10000000}

    init(profile: UserProfile, remoteSession: RemoteUserSession) {
    self.profile = profile
    self.remoteSession = remoteSession
  }
    
    public var logInDate: Date {
        remoteSession.createdOn
    }
}

