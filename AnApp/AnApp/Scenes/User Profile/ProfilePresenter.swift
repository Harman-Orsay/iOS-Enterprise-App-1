//
//  ProfilePresenter.swift
//  AnApp
//
//  Created by Rohan Ramsay on 11/01/21.
//

import AnAppKit
import AnAppUIKit
import Combine

protocol LogOutResponder: Responder {
    func loggedOut()
}

protocol ProfileUI: UI {
    func show(name: String, email: String, phone: String, lastLogin: String)
    func showError(title: String, message: String)
}

class ProfilePresenter: Presenter {
    
    weak var ui: ProfileUI!
    var logoutResponder: LogOutResponder
    var useCase: LogOutUseCase
    var session: UserSession
    var subscriptions = Set<AnyCancellable>()
    
    init(session: UserSession, logoutResponder: LogOutResponder, useCase: LogOutUseCase) {
        self.logoutResponder = logoutResponder
        self.useCase = useCase
        self.session = session
    }
    
    func uiDidLoad() {
        ui.show(name: session.profile.name, email: session.profile.email, phone: session.profile.phone, lastLogin: session.logInDate.description)
    }
    
    func logout() {
        useCase.execute(onStart: {})
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .finished: self.logoutResponder.loggedOut()
                case .failure(let error):
                    self.ui.showError(title: "Logout Error", message: error.localizedDescription)
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
    }
}
