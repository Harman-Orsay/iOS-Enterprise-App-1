//
//  UserDataRepository.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine

class PersistentUserRepository {
    
    private let service: UserService
    private let dataStore: UserDataStore
    
    private var userPublisher = CurrentValueSubject<[User], Never>([])
    private var cache: [User] = [] {
        didSet {
            userPublisher.send(Array(cache[0 ..< userPublisher.value.count]))
        }
    }
    private var cacheSubscription: Cancellable? = nil
    private let pageSize = 20

    init(service: UserService, dataStore: UserDataStore) {
        self.service = service
        self.dataStore = dataStore
        readUsers(sortedBy: User.SortableField.default)
    }
    
    private func readUsers(sortedBy field: User.SortableField) {
        cacheSubscription?.cancel()
        cacheSubscription = dataStore.read(sortedBy: field)
            .assign(to: \.cache, on: self)
    }
}

extension PersistentUserRepository: UserRepository {

    var users: AnyPublisher<[User], Never> {
        userPublisher.eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<Void, APIError.User> {
        service.add(user: user)
            .handleEvents(receiveOutput: {self.dataStore.add(users: [$0])})
            .map{_ in}
            .eraseToAnyPublisher()
    }
    
    func delete(user: User) -> AnyPublisher<Void, APIError.User> {
        service.delete(user: user)
            .handleEvents(receiveOutput: {self.dataStore.delete(user: user)})
            .map{_ in}
            .eraseToAnyPublisher()
    }
    
    func getMore() -> AnyPublisher<Void, APIError.User> {
        guard cache.count == userPublisher.value.count else {
            let countToReturn = cache.count > userPublisher.value.count + pageSize ? userPublisher.value.count + pageSize : cache.count
            userPublisher.send(Array(cache[0 ..< countToReturn]))
            return Just(()).mapError{_ in APIError.User.network}.eraseToAnyPublisher()
        }
        
        return service.fetchNextPage()
            .handleEvents(receiveOutput: {self.dataStore.add(users: $0)})
            .map{_ in}
            .eraseToAnyPublisher()
    }
    
    func sort(by field: User.SortableField) {
        readUsers(sortedBy: field)
    }
}
