//
//  TabBarViewController.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 21/12/20.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    var userListPresenter: UserListPresenter!
    var userListViewFactory: UserListViewControllerFactory!
    var profilePresenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userListVC = (viewControllers?.first as? UINavigationController)?.viewControllers.first as? UserListViewController {
            userListVC.presenter = userListPresenter
            userListVC.viewControllerFactory = userListViewFactory
        }
        
        if let profileVC = (viewControllers?.last as? UINavigationController)?.viewControllers.first as? ProfileViewController {
            profilePresenter.ui = profileVC
            profileVC.presenter = profilePresenter
        }
    }
}
