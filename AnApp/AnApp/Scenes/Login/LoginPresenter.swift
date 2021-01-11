//
//  LoginPresenter.swift
//  AnApp
//
//  Created by Rohan Ramsay on 12/01/21.
//

import AnAppKit
import AnAppUIKit
import Combine


protocol LoginResponder: Responder {
    func loggedIn(session: UserSession)
}

protocol SignUpNavigator: Navigator {
    func navigateToSignUp()
}

protocol LoginUI: UI {
    func showError(title: String, message: String)
    func updateActivityIndicator(show: Bool)
}

class LoginPresenter: Presenter {

    weak var ui: LoginUI!
    var loginResponder: LoginResponder
    var signupNavigator: SignUpNavigator
    var useCaseFactory: LoginUseCaseFactory
    private var subscriptions = Set<AnyCancellable>()

    init(loginResponder: LoginResponder, signupNavigator: SignUpNavigator, useCaseFactory: LoginUseCaseFactory) {
        self.loginResponder = loginResponder
        self.signupNavigator = signupNavigator
        self.useCaseFactory = useCaseFactory
    }
    
    func actionSignUp() {
        signupNavigator.navigateToSignUp()
    }
    
    func actionLogin(username: String?, password: String?) {
        guard let username = username?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = password?.trimmingCharacters(in: .whitespacesAndNewlines),
              username != "", password != "" else {
            ui.showError(title: "Error", message: "Enter username & password")
            return
        }
        
        useCaseFactory.makeLoginUseCase(username: username, password: password)
            .execute(onStart: {self.ui.updateActivityIndicator(show: true)})
            .sink(receiveCompletion: { completion in
                
                self.ui.updateActivityIndicator(show: false)
                if case .failure(let error) = completion {
                    self.ui.showError(title: "Could not login", message: error.localizedDescription)
                }
                
            }, receiveValue: { session in
                self.loginResponder.loggedIn(session: session)
            })
            .store(in: &subscriptions)
    }
}

protocol LoginUseCaseFactory {
    func makeLoginUseCase(username: String, password: String) -> LoginUseCase
}
