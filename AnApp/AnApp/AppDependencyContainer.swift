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
    
    let presenterContainer: PresenterFactory
    let viewControllerFactory: ViewControllerFactory
    let userDataDIFactory: UserDataDependencyFactory
    
    init() {
       let di =  AnAppKitDependencyFactory()
        self.presenterContainer = PresenterFactory(sessionUseCaseFactory: di.makeUserSessionDependencyFactory().makeUserSessionUseCaseFactory())
        self.userDataDIFactory = di.makeUserDataDependencyFactory()
        self.viewControllerFactory = ViewControllerFactory()
    }
    
    func makeMainViewController() -> MainViewController {
        viewControllerFactory.makeMainViewController(presenter: presenterContainer.makeMainPresenter(), viewFactory: self)
    }
}

extension AppDependencyContainer: MainVCViewFactory {
    
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
        let userListDI = UserListDependencyContainer(factory: userDataDIFactory)
        return viewControllerFactory.makeHomeViewController(userListViewFactory: userListDI.makeUserListViewControllerFactory(),
                                                     userListPresenter: userListDI.makeUserListPresenter(),
                                                     profilePresenter: presenterContainer.makeProfilePresenter(session: userSession))
    }
}

class PresenterFactory {
    
    private let sessionUseCaseFactory: UserSessionUseCaseFactory
    private let mainPresenter: MainPresenter
    
    init(sessionUseCaseFactory: UserSessionUseCaseFactory) {
        
        func makeMainPresenter() -> MainPresenter {
            MainPresenter()
        }
        
        self.sessionUseCaseFactory = sessionUseCaseFactory
        self.mainPresenter = makeMainPresenter()
    }
   
    func makeMainPresenter() -> MainPresenter {
        mainPresenter
    }
    
    func makeLoginPresenter() -> LoginPresenter {
        LoginPresenter(loginResponder: mainPresenter, signupNavigator: mainPresenter, useCaseFactory: self)
    }
    
    func makeLaunchPresenter() -> LaunchPresenter {
        LaunchPresenter(useCase: sessionUseCaseFactory.makeCheckLoginStatusUseCase(), responder: mainPresenter)
    }
    
    func makeProfilePresenter(session: UserSession) -> ProfilePresenter {
        ProfilePresenter(session: session,
                         logoutResponder: mainPresenter,
                         useCase: sessionUseCaseFactory.makeLogOutUseCase())
    }
}

extension PresenterFactory: LoginUseCaseFactory {
    func makeLoginUseCase(username: String, password: String) -> LoginUseCase {
        sessionUseCaseFactory.makeLoginUseCase(username: username, password: password)
    }
}

class ViewControllerFactory {
        
    func makeMainViewController(presenter: MainPresenter, viewFactory: MainVCViewFactory) -> MainViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        presenter.ui = vc
        vc.presenter = presenter
        vc.viewFactory = viewFactory
        return vc
    }
    
    func makeLoginViewController(presenter: LoginPresenter) -> LoginViewController{
        let vc = UIStoryboard(name: "Login", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.presenter = presenter
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

    func makeLaunchViewController(presenter: LaunchPresenter) -> LaunchViewController {
        let vc = UIStoryboard(name: "Launch", bundle: nil)
            .instantiateViewController(withIdentifier: "LaunchVC") as! LaunchViewController
        vc.modalPresentationStyle = .fullScreen
        vc.presenter = presenter
        return vc
    }
}


