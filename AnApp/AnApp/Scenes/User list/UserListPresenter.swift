//
//  UserListPresenter.swift
//  AnApp
//
//  Created by Rohan Ramsay on 12/01/21.
//

import Combine
import AnAppKit
import AnAppUIKit

enum UserListViewAction {
    case initial
    case add
    case sort(User.SortableField)
    case list
    case dismiss
}

protocol UserListUI: UI {
    func show(users: [User])
    func perform(action: UserListViewAction)
    func showError(title: String, message: String)
    func updateActivityIndicator(show: Bool)
    func updateLoadMoreActivityIndicator(state: LoadingIndicatorTableHeaderFooterView.State)
}

class UserListPresenter: Presenter {
    weak var ui: UserListUI!
    var useCaseFactory: UserUseCaseFactory
    
    private var subscriptions = Set<AnyCancellable>()
    private var fetching: Bool = false
    
    private var sortField: User.SortableField = .id {
        didSet {
            sort(field: sortField)
        }
    }
    
    private var users = [User]() {
        didSet {
            ui.show(users: users)
        }
    }

    init(factory: UserUseCaseFactory) {
        self.useCaseFactory = factory
    }    
}

extension UserListPresenter {

    func uiDidLoad() {
        useCaseFactory.makeGetUserUseCase()
            .execute(onStart: nil)
            .sink {
                self.users = $0
                
            }
            .store(in: &subscriptions)
    }
    
    func actionSort() {
        ui.perform(action: .sort(sortField))
    }
    
    func actionAdd() {
        ui.perform(action: .add)
    }
    
    func actionList() {
        ui.perform(action: .list)
    }
}

extension UserListPresenter {
    
    func delete(user: User) {
        useCaseFactory.makeDeleteUserUseCase(user: user)
            .execute(onStart: { self.ui.updateActivityIndicator(show: true)})
            .sink(receiveCompletion: { completion in
                self.ui.updateActivityIndicator(show: false)
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.ui.show(users: self.users)
                    self.ui.showError(title: "Could not delete user", message: error.localizedDescription)
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
    }
    
    func fetchMore() {
        guard !fetching else { return }

        useCaseFactory.makeLoadNextUsersPageUseCase()
            .execute(onStart: {self.fetching = true})
            .sink(receiveCompletion: { completion in
                self.fetching = false
                switch completion {
                case .finished: self.ui.updateLoadMoreActivityIndicator(state: .completed(message: nil))
                case .failure(let error): self.ui.updateLoadMoreActivityIndicator(state: .completed(message: error.localizedDescription))
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
    }
    
    func sort(field: User.SortableField) {
        useCaseFactory.makeSortUserUseCase(sortField: field)
            .execute(onStart: nil)
    }
    
    func add(user: User) {
        useCaseFactory.makeAddUserUseCase(user: user)
            .execute(onStart: {self.ui.updateActivityIndicator(show: true)})
            .sink(receiveCompletion: { [weak self]
                completion in
                self?.ui.updateActivityIndicator(show: false)
                switch completion {
                case .finished: break
                case .failure(let error): self?.ui.showError(title: "Could not add user", message: error.localizedDescription)
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
    }
}

extension UserListPresenter: AddUserResponder {
    func canceled() {
        ui.perform(action: .dismiss)
    }
    
    func created(user: User) {
        ui.perform(action: .dismiss)
        add(user: user)
    }
}

extension UserListPresenter: SortFieldSelectionResponder {
    func selected(field: User.SortableField) {
        sortField = field
    }
}
