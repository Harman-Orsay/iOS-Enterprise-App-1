//
//  UserProfile.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 12/01/21.
//

import Foundation

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
