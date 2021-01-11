//
//  MainPresenter.swift
//  AnApp
//
//  Created by Rohan Ramsay on 11/01/21.
//

import AnAppKit
import AnAppUIKit

enum MainViewAction {
    case launch
    case login
    case signup
    case home(session: UserSession)
}

protocol MainUI: UI{
    func perform(action: MainViewAction)
}

class MainPresenter: Presenter {
    weak var ui: MainUI!
    
    func uiDidLoad() {
        ui.perform(action: .launch)
    }
}

extension MainPresenter: LaunchResponder {
    func appLaunched(with state: CurrentSessionState) {
        switch state {
        case .notSignedIn: ui.perform(action: .login)
        case .signedIn(let session): ui.perform(action: .home(session: session))
        }
    }
}

extension MainPresenter: LoginResponder {
    func loggedIn(session: UserSession) {
        ui.perform(action: .home(session: session))
    }
}

extension MainPresenter: SignUpNavigator {
    func navigateToSignUp() {
        ui.perform(action: .signup)
    }
}

extension MainPresenter: LogOutResponder {
    func loggedOut() {
        ui.perform(action: .launch)
    }
}
