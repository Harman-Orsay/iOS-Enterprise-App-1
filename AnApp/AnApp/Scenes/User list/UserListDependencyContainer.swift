//
//  UserListDependencyContainer.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 21/12/20.
//

import Foundation
import UIKit
import AnAppKit

class UserListDependencyContainer {
    
    private let factory: UserDataDependencyFactory
    private let presenter: UserListPresenter
    
    init(factory: UserDataDependencyFactory) {
        
        func makeUserListPresenter(useCaseFactory: UserUseCaseFactory) -> UserListPresenter {
            UserListPresenter(factory: useCaseFactory)
        }
        
        self.factory = factory
        self.presenter = makeUserListPresenter(useCaseFactory: factory.makeUseCaseFactory())
    }
    
    func makeUserListViewModel() -> UserListViewModel {
        UserListViewModel(repository: factory.makeRepository())
    }
    
    func makeUserListPresenter() -> UserListPresenter {
        presenter
    }
    
    func makeUserListViewControllerFactory() -> UserListViewControllerFactory {
        self
    }
    
    func makeAddUserViewModel(responder: AddUserResponder) -> AddUserViewModel {
        AddUserViewModel(responder: responder)
    }
    
    func makeSortFieldsViewModel(responder: SortFieldSelectionResponder, selectedField: User.SortableField) ->SortFieldsViewModel {
        SortFieldsViewModel(currentSortField: selectedField, responder: responder)
    }
}

extension UserListDependencyContainer: UserListViewControllerFactory {
    func makeAddUserNavigationController() -> UINavigationController {
        let navC = UIStoryboard(name: "AddUser", bundle: nil).instantiateViewController(withIdentifier: "AddUserNavC") as! UINavigationController
        let vc = navC.viewControllers.first as! AddUserViewController
        vc.viewModel = makeAddUserViewModel(responder: presenter)
        return navC
    }
    
    func makeSortFieldsNavigationController(selectedField: User.SortableField) -> UINavigationController {
        let navC = UIStoryboard(name: "SortUser", bundle: nil).instantiateViewController(withIdentifier: "SortNavC") as! UINavigationController
        let vc = navC.viewControllers.first as! SortFieldsTableViewController
        vc.viewModel = makeSortFieldsViewModel(responder: presenter, selectedField: selectedField)
        return navC
    }
}

protocol UserListViewControllerFactory {
    func makeAddUserNavigationController() -> UINavigationController
    func makeSortFieldsNavigationController(selectedField: User.SortableField) -> UINavigationController
}

class UserPresenterFactory {
    
}
