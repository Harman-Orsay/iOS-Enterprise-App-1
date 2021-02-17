//
//  UIAlertController.swift
//  AnAppUIKit
//
//  Created by Rohan Ramsay on 17/02/21.
//

import UIKit

public extension UIAlertController {
    
    @discardableResult
    func showIn(window: UIWindow, animated: Bool = false, completion: (() -> Void)? = nil) -> Bool {
        guard let rootVC = window.rootViewController else {return false}
        
        if self.actions.count == 0{
            let okAction = UIAlertAction(title: "OK", style: .default)
            self.addAction(okAction)
        }

        getTopMostViewController(on: rootVC).present(self, animated: animated, completion: completion)
        return true
    }
    
    private func getTopMostViewController(on viewController: UIViewController) -> UIViewController {
        if let topVC = viewController.presentedViewController {
            return getTopMostViewController(on: topVC)
        } else {
            if let navC = viewController as? UINavigationController {
                return navC.topViewController ?? navC
            }
            if let tabC = viewController as? UITabBarController {
                return tabC.selectedViewController ?? tabC
            }
            return viewController
        }
    }
}
