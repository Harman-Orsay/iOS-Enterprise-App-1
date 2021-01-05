//
//  AppDependencyContainer.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 21/12/20.
//

import Foundation
import AnAppKit

class AppDependencyContainer {
    
    let appDependecyFactory = AnAppKitDependencyFactory()
    
    var userList: UserListDependencyContainer {
        UserListDependencyContainer(factory: appDependecyFactory.makeUserDataDependencyFactory())
    }
}
