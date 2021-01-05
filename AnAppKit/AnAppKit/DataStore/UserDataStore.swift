//
//  DataStore.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 4/01/21.
//

import Combine

protocol UserDataStore {
    func delete(user: User)
    func add(users: [User])
    func read(sortedBy field: User.SortableField) -> AnyPublisher<[User], Never>
}
