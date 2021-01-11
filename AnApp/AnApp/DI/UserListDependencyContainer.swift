//
//  UserListDependencyContainer.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 21/12/20.
//

import UIKit
import AnAppKit

class UserListDependencyContainer {
    
    let useCaseFactory: UserUseCaseFactory
    let viewControllerFactory: ViewControllerFactory
    let sharedPresenter: UserListPresenter
    
    init(useCaseFactory: UserUseCaseFactory, viewControllerFactory: ViewControllerFactory) {
        
        func makeUserListPresenter(useCaseFactory: UserUseCaseFactory) -> UserListPresenter {
            UserListPresenter(factory: useCaseFactory)
        }
        
        self.viewControllerFactory = viewControllerFactory
        self.useCaseFactory = useCaseFactory
        self.sharedPresenter = makeUserListPresenter(useCaseFactory: useCaseFactory)
    }
    
    func makeUserListPresenter() -> UserListPresenter {
        sharedPresenter
    }
    
    func makeUserListViewControllerFactory() -> UserListViewControllerFactory {
        self
    }   
}

extension UserListDependencyContainer: UserListViewControllerFactory {
   
    func makeAddUserNavigationController() -> UINavigationController {
        viewControllerFactory.makeAddUserNavigationController(viewModel: makeAddUserViewModel(responder: sharedPresenter))
    }
    
    func makeSortFieldsNavigationController(selectedField: User.SortableField) -> UINavigationController {
        viewControllerFactory.makeSortFieldsNavigationController(selectedField: selectedField, viewModel: makeSortFieldsViewModel(responder: sharedPresenter, selectedField: selectedField))
    }
}

extension UserListDependencyContainer {
    
    func makeAddUserViewModel(responder: AddUserResponder) -> AddUserViewModel {
        AddUserViewModel(responder: responder)
    }
    
    func makeSortFieldsViewModel(responder: SortFieldSelectionResponder, selectedField: User.SortableField) ->SortFieldsViewModel {
        SortFieldsViewModel(currentSortField: selectedField, responder: responder)
    }
}
