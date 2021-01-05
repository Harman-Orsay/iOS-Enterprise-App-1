//
//  RealmUserDataStore.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 4/01/21.
//

import RealmSwift
import Combine

class RealmUserDataStore {
   
    var publisher = PassthroughSubject<[User], Never>()
    var notificationToken: NotificationToken?
    
    func loadUsers(sortedBy field: User.SortableField) {
        notificationToken?.invalidate()
        let users = RlmUser.all(sortedBy: field.RLMKeyPath)
        notificationToken = users.observe{[weak self] _ in
            self?.publisher.send(users.map{$0.user})
        }
    }
}

extension RealmUserDataStore: UserDataStore {
    
    func read(sortedBy field: User.SortableField) -> AnyPublisher<[User], Never> {
        loadUsers(sortedBy: field)
        return publisher.eraseToAnyPublisher()
    }
    
    func delete(user: User) {
        RlmUser.delete(user: user)
    }
    
    func add(users: [User]) {
        RlmUser.add(users: users)
    }
}

extension User.SortableField {
    
    var RLMKeyPath: String {
        switch self {
        case .name: return "name"
        case .id: return "id"
        case .lastUpdated: return "updatedAt"
        }
    }
}
