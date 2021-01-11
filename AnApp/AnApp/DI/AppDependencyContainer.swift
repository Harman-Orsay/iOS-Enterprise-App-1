//
//  AppDependencyContainer.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 21/12/20.
//

import Foundation
import AnAppKit
import UIKit

class AppDependencyContainer { //for main scene, when there another complex scene sprouts from main - u create a depndency container for that here
    
    let presenterContainer: PresenterContainer
    let viewControllerFactory: ViewControllerFactory
    let sharedUserUseCaseFactory: UserUseCaseFactory
    
    init() {
        let anAppKitDI = AnAppKitDependencyFactory()
        
        self.presenterContainer = PresenterContainer(sessionUseCaseFactory: anAppKitDI.makeUserSessionDependencyFactory().makeUseCaseFactory())
        self.viewControllerFactory = ViewControllerFactory()
        self.sharedUserUseCaseFactory = anAppKitDI.makeUserDependencyFactory().makeUseCaseFactory()
    }
    
    func makeMainViewController() -> MainViewController {
        viewControllerFactory.makeMainViewController(presenter: presenterContainer.makeMainPresenter(), viewControllerFactory: self)
    }
    
    class PresenterContainer {
        
        private let sessionUseCaseFactory: UserSessionUseCaseFactory
        private let sharedMainPresenter: MainPresenter
        
        init(sessionUseCaseFactory: UserSessionUseCaseFactory) {
            
            func makeMainPresenter() -> MainPresenter {
                MainPresenter()
            }
            
            self.sessionUseCaseFactory = sessionUseCaseFactory
            self.sharedMainPresenter = makeMainPresenter()
        }
       
        func makeMainPresenter() -> MainPresenter {
            sharedMainPresenter
        }
        
        func makeLoginPresenter() -> LoginPresenter {
            LoginPresenter(loginResponder: sharedMainPresenter, signupNavigator: sharedMainPresenter, useCaseFactory: self)
        }
        
        func makeLaunchPresenter() -> LaunchPresenter {
            LaunchPresenter(useCase: sessionUseCaseFactory.makeCheckLoginStatusUseCase(), responder: sharedMainPresenter)
        }
        
        func makeProfilePresenter(session: UserSession) -> ProfilePresenter {
            ProfilePresenter(session: session,
                             logoutResponder: sharedMainPresenter,
                             useCase: sessionUseCaseFactory.makeLogOutUseCase())
        }
    }
}

extension AppDependencyContainer: MainViewControllerFactory {
    
    func makeLaunchViewController() -> LaunchViewController {
        viewControllerFactory.makeLaunchViewController(presenter: presenterContainer.makeLaunchPresenter())
    }
    
    func makeLoginViewController() -> LoginViewController {
        viewControllerFactory.makeLoginViewController(presenter: presenterContainer.makeLoginPresenter())
    }
    
    func makeSignUpViewController() -> UIViewController { //dummy
        UIViewController()
    }
    
    func makeHomeViewController(userSession: UserSession) -> HomeTabBarViewController {
        let userListDI = UserListDependencyContainer(useCaseFactory: sharedUserUseCaseFactory, viewControllerFactory: viewControllerFactory)
        
        return viewControllerFactory.makeHomeViewController(userListViewFactory: userListDI.makeUserListViewControllerFactory(),
                                                     userListPresenter: userListDI.makeUserListPresenter(),
                                                     profilePresenter: presenterContainer.makeProfilePresenter(session: userSession))
    }
}

extension AppDependencyContainer.PresenterContainer: LoginUseCaseFactory {
    func makeLoginUseCase(username: String, password: String) -> LoginUseCase {
        sessionUseCaseFactory.makeLoginUseCase(username: username, password: password)
    }
}

