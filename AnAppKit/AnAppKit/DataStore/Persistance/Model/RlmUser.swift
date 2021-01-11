//
//  RlmUser.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import RealmSwift

class RlmUser: Object {
        
    @objc dynamic var id: Int = -1
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var genderRaw: String = ""
    @objc dynamic var statusRaw: String = ""
    @objc dynamic var lastUpdated: Date?
    @objc dynamic var primaryKey: String = ""

    static var writer: WorkerThread {
        WorkerThread(name: "RlmUser.Writer")
    }
    
    override class func primaryKey() -> String? {
        "primaryKey"
    }

    convenience init(user: User) {
        self.init()
        id = user.id
        name = user.email
        email = user.email
        genderRaw = user.gender.rawValue
        statusRaw = user.status.rawValue
        lastUpdated = user.lastUpdated
        primaryKey = user.rlmPrimaryKey
    }
    
    var user: User {
        User(id: id,
             name: name,
             email: email,
             gender: User.Gender(rawValue: genderRaw) ?? .female,
             status: User.Status(rawValue: statusRaw) ?? .active,
             lastUpdated: lastUpdated ?? Date())
    }
}

extension RlmUser {
    static func add(users: [User]) {
        autoreleasepool {
            writer.enqueue {
                let realm = rlm
                try? realm.write {
                    realm.add(users.map{RlmUser(user: $0)}, update: .all)
                }
            }
        }
    }
    
    static func delete(user: User) {
        writer.enqueue {
            let realm = rlm
            try? realm.write {
            if let object = realm.object(ofType: Self.self, forPrimaryKey: user.id) {
                realm.delete(object)
            }
            }
        }
    }
    
    static func all(sortedBy keyPath: String) -> Results<RlmUser> {
        return readOnlyRlm.objects(RlmUser.self).sorted(byKeyPath: keyPath)
    }
}

extension User {
    var rlmPrimaryKey: String {
        id > 0 ? "\(id)" : Date().description
    }
}
