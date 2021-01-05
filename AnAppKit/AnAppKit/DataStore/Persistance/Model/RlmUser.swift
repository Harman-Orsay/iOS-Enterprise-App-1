//
//  RlmUser.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import RealmSwift

class RlmUser: Object {
    
    dynamic var name: String = ""
    dynamic var id: Int = -1
    dynamic var updatedAt: Date?
    dynamic var primaryKey: String = ""
    
    static var writer: WorkerThread {
        WorkerThread(name: "RlmUser.Writer")
    }
    
    override class func primaryKey() -> String? {
        "primaryKey"
    }
    
    func getPrimaryKey() -> String {
        id > 0 ? "\(id)" : Date().description
    }
    
    convenience init(user: User) {
        self.init()
        name = user.email
        id = user.id
    }
    
    var user: User {
        User(id: 0, name: name, email: "", gender: .female, status: .active, lastUpdated: Date())
    }
    
    static func add(users: [User]) {
        autoreleasepool {
            writer.enqueue {
                rlm.add(users.map{RlmUser(user: $0)}, update: .all)
            }
        }
    }
    
    static func delete(user: User) {
        writer.enqueue {
            if let object = rlm.object(ofType: Self.self, forPrimaryKey: user.id) {
                rlm.delete(object)
            }
        }
    }
    
    static func all(sortedBy keyPath: String) -> Results<RlmUser> {
        return readOnlyRlm.objects(RlmUser.self).sorted(byKeyPath: keyPath)
    }
}

extension RlmUser {
    

}
