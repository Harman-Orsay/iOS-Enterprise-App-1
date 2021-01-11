//
//  LoginViewController.swift
//  AnApp
//
//  Created by Rohan Ramsay on 7/01/21.
//

import UIKit
import AnAppKit
import AnAppUIKit

class LoginViewController: UIViewController {

    var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.uiDidLoad()
    }
    

}

protocol LoginResponder: Responder {
    func loggedIn(session: UserSession)
}

protocol SignUpNavigator: Navigator {
    func navigateToSignUp()
}

protocol LoginUI: UI {
    func showError(title: String, message: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

class LoginPresenter: Presenter {
    func uiDidLoad() {
        
    }
    
    weak var ui: LoginUI!
    var loginResponder: LoginResponder
    var signupNavigator: SignUpNavigator
    var useCaseFactory: LoginUseCaseFactory
    
    init(loginResponder: LoginResponder, signupNavigator: SignUpNavigator, useCaseFactory: LoginUseCaseFactory) {
        self.loginResponder = loginResponder
        self.signupNavigator = signupNavigator
        self.useCaseFactory = useCaseFactory
    }
}

protocol LoginUseCaseFactory {
    func makeLoginUseCase(username: String, password: String) -> LoginUseCase
}
