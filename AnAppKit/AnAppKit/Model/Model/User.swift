//
//  User.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

public struct User {
    public var id: Int
    public var email: String
    public var name: String
    public var gender: Gender
    public var status: Status
    public var lastUpdated: Date
    
    public init(name: String, email: String, gender: Gender, status: Status, createdOn: Date) {
        self.id = -1
        self.name = name
        self.email = email
        self.gender = gender
        self.status = status
        self.lastUpdated = createdOn
    }
    
    public init(id: Int, name: String, email: String, gender: Gender, status: Status, lastUpdated: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.gender = gender
        self.status = status
        self.lastUpdated = lastUpdated
    }
}

extension User {

    public enum Gender: String {
        case male = "Male"
        case female = "Female"
    }
    
    public enum Status: String {
        case active = "Active"
        case inactive = "Inactive"
    }

    public enum SortableField: String {
        case name = "Name"
        case id = "Id"
        case lastUpdated = "Most recently updated"
        
        public static var all: [Self] {
            [.id, .name, .lastUpdated]
        }
        
        public static var `default`: Self {
            .id
        }
    }
}

extension User {
    static func sorter(_ user1: User, _ user2: User, by field: SortableField) -> Bool{
        switch field {
        case .name: return user1.name.lowercased() < user2.name.lowercased()
        case .id: return user1.id < user2.id
        case .lastUpdated: return user1.lastUpdated > user2.lastUpdated
        }
    }
}


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

public struct UserProfile: Codable {

  public let name: String
  public let email: String
    public let phone: String


  public init(name: String, email: String, mobileNumber: String) {
    self.name = name
    self.email = email
    self.phone = mobileNumber
  }
}
