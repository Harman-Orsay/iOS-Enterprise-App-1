//
//  LaunchPresenter.swift
//  AnApp
//
//  Created by Rohan Ramsay on 11/01/21.
//

import AnAppKit
import AnAppUIKit
import Combine


enum CurrentSessionState {
    case notSignedIn
    case signedIn(session: UserSession)
    //add more - signed In FRE seen, FRE not seen, account confirmed, not confirmed etc.
}

protocol LaunchResponder {
    func appLaunched(with state: CurrentSessionState)
}

class LaunchPresenter: Presenter {
    let useCase: CheckLoginStatusUseCase
    let responder: LaunchResponder
    var subscriptions = Set<AnyCancellable>()
    
    init(useCase: CheckLoginStatusUseCase, responder: LaunchResponder) {
        self.useCase = useCase
        self.responder = responder
    }
    
    func uiDidLoad() {
        useCase.execute(onStart: nil)
            .sink(receiveCompletion: { completion in
                self.responder.appLaunched(with: .notSignedIn)
            }, receiveValue: { session in
                self.responder.appLaunched(with: .signedIn(session: session))
            })
            .store(in: &subscriptions)
    }
}
