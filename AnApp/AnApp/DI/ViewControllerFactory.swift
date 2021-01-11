//
//  ViewControllerFactory.swift
//  AnApp
//
//  Created by Rohan Ramsay on 12/01/21.
//

import UIKit
import AnAppKit

class ViewControllerFactory {
        
    func makeMainViewController(presenter: MainPresenter, viewControllerFactory: MainViewControllerFactory) -> MainViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        presenter.ui = vc
        vc.presenter = presenter
        vc.viewControllerFactory = viewControllerFactory
        return vc
    }
    
    func makeLaunchViewController(presenter: LaunchPresenter) -> LaunchViewController {
        let vc = UIStoryboard(name: "Launch", bundle: nil)
            .instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
        vc.modalPresentationStyle = .fullScreen
        vc.presenter = presenter
        return vc
    }

    func makeLoginViewController(presenter: LoginPresenter) -> LoginViewController{
        let vc = UIStoryboard(name: "Login", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.presenter = presenter
        presenter.ui = vc
        return vc
    }
    
    func makeHomeViewController(userListViewFactory: UserListViewControllerFactory, userListPresenter: UserListPresenter, profilePresenter:  ProfilePresenter) -> HomeTabBarViewController {
       let tabC = UIStoryboard(name: "Home", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeTabBarViewController") as! HomeTabBarViewController
        tabC.modalPresentationStyle = .fullScreen
        tabC.profilePresenter = profilePresenter
        tabC.userListPresenter = userListPresenter
        tabC.userListViewFactory = userListViewFactory
        return tabC
    }

    func makeAddUserNavigationController(viewModel: AddUserViewModel) -> UINavigationController {
        let navC = UIStoryboard(name: "AddUser", bundle: nil).instantiateViewController(withIdentifier: "AddUserNavC") as! UINavigationController
        let vc = navC.viewControllers.first as! AddUserViewController
        vc.viewModel = viewModel
        return navC
    }
    
    func makeSortFieldsNavigationController(selectedField: User.SortableField, viewModel: SortFieldsViewModel) -> UINavigationController {
        let navC = UIStoryboard(name: "SortUser", bundle: nil).instantiateViewController(withIdentifier: "SortNavC") as! UINavigationController
        let vc = navC.viewControllers.first as! SortFieldsTableViewController
        vc.viewModel = viewModel
        return navC
    }
}
