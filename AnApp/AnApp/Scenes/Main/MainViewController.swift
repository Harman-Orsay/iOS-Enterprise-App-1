//
//  MainViewController.swift
//  AnApp
//
//  Created by Rohan Ramsay on 7/01/21.
//

import UIKit
import AnAppKit

class MainViewController: UIViewController {

    var presenter: MainPresenter!
    var viewControllerFactory: MainViewControllerFactory!
    var loaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !loaded else { return }
        loaded = true
        presenter.uiDidLoad()
    }
    
    func presentViewController(action: MainViewAction) {
        switch action {
        case .launch: present(viewControllerFactory.makeLaunchViewController(), animated: false, completion: nil)
        case .login: present(viewControllerFactory.makeLoginViewController(), animated: true, completion: nil)
        case .signup: break
        case .home(let session): present(viewControllerFactory.makeHomeViewController(userSession: session), animated: true, completion: nil)
        }
    }
}

extension MainViewController: MainUI {
    func perform(action: MainViewAction) {
        if let presentedVC = presentedViewController {
            if case .signup = action { //Dummy
                presentedVC.presentAlert(title: "Sign up not implemented", message: "Enter any username & password to login")
                return
            }

            presentedVC.dismiss(animated: false, completion: {
                self.presentViewController(action: action)
            })

        } else {
            presentViewController(action: action)
        }        
    }    
}

protocol MainViewControllerFactory {
    func makeLaunchViewController() -> LaunchViewController
    func makeLoginViewController() -> LoginViewController
    func makeSignUpViewController() -> UIViewController
    func makeHomeViewController(userSession: UserSession) -> HomeTabBarViewController
}

/*
 DO not supply configuration dependencies that factory is aware of at compile time
 e.g. responders - view factory knows who the reosnder for for a view is, dont pass tha instance to it.
 pass stuff that may become available only at runtime. e.g. session token
 it might happen that there can be multiple instances of responder are available from which a sleection is made at runtime based on the scenario - then do pass them around
 */


