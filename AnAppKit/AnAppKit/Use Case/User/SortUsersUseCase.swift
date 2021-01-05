//
//  SortUsersUseCase.swift
//  AnAppKit
//
//  Created by Rohan Ramsay on 5/01/21.
//

import Foundation


public class SortUsersUseCase: UseCase {
    public typealias Result = Void

    private let repository: UserRepository
    private let sortField: User.SortableField

    init(repository: UserRepository, sortField: User.SortableField) {
        self.repository = repository
        self.sortField = sortField
    }
    
    public func execute(onStart: (() -> Void)?) -> Void {
        repository.sort(by: sortField)
    }
}



