//
//  File.swift
//
//  Created by Rohan Ramsay on 20/08/21.
//

import RealmSwift
import Utility

fileprivate struct RealmProvider {
    let configuration: Realm.Configuration
    
    internal init(config: Realm.Configuration){
        configuration = config
    }
    
    var realm: Realm {
        return try! Realm(configuration: configuration)
    }
    var readOnlyRealm: Realm {
        var config = self.configuration
        config.readOnly = true
        return try! Realm(configuration: configuration)
    }
    
    private static let realmSecureBasePath: URL? = Path.inAppSupportDirectory(directory: "Realm.secure")
    private static let secureUsersConfig = Realm.Configuration(fileURL: Path.inDirectory(at: realmSecureBasePath, fileName: "users.realm"),
                                                               schemaVersion: usersSchemaVersion)
    static let users: RealmProvider = RealmProvider(config: secureUsersConfig)
    
    static func deleteAll() {
        let realms: [Realm] = [users.realm]
        
        for realm in realms {
            try? realm.write {
                realm.deleteAll()
            }
        }
    }
    
    static func deleteFromRealmWriter() {
            deleteAll()
    }
    
    fileprivate static func initialiseAndMigrate() {
        let configs: [(Realm.Configuration, UInt64)] = [(secureUsersConfig, usersSchemaVersion)]
        
        for (config, version) in configs {
            addMigrationAndCompactionBlocksAndOpen(realmConfig: config, newSchemaVersion: version)
        }
        
        deleteDefaultRealm()
    }
    
    private static func addMigrationAndCompactionBlocksAndOpen(realmConfig: Realm.Configuration, newSchemaVersion: UInt64) {
        autoreleasepool{
            let fiftyMB = 50 * 1024 * 1024
            var modifiedConfig = realmConfig
            modifiedConfig.migrationBlock = {
                _, oldSchemaVersion in
                if (oldSchemaVersion < newSchemaVersion) {}
            }
            modifiedConfig.shouldCompactOnLaunch = {
                totalBytes, usedBytes in
                return totalBytes > fiftyMB && Double(usedBytes / totalBytes) < 0.5
            }
            _ = try? Realm(configuration: modifiedConfig)
        }
    }
    
    private static func deleteDefaultRealm() {
        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    }
}

extension RealmProvider {
    static let usersSchemaVersion: UInt64 = 1
    static let usersTypes: [Object.Type] = [RlmUser.self]
}

extension RlmUser {
    static var readOnlyRlm: Realm {
        return RealmProvider.users.readOnlyRealm
    }
    static var rlm: Realm {
        return RealmProvider.users.realm
    }
}
