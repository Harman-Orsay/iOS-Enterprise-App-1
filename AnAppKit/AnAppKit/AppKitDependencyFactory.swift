//
//  AppKitDependencyFactory.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Foundation

public class AnAppKitDependencyFactory {
    public init() {}
    
    public func makeUserDependencyFactory() -> UserDependencyFactory {
        UserDataDependencyFactoryFactory()
    }
    
    public func makeUserSessionDependencyFactory() -> UserSessionDependencyFactory {
        UserSessionDependencyFactoryFactory()
    }
}
