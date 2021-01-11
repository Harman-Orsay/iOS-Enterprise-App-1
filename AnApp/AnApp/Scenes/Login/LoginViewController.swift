//
//  LoginViewController.swift
//  AnApp
//
//  Created by Rohan Ramsay on 7/01/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let activityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .large)
      indicator.hidesWhenStopped = true
      return indicator
    }()
    
    var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.uiDidLoad()
    }
    @IBAction func loginTapped(_ sender: Any) {
        presenter.actionLogin(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        presenter.actionSignUp()
    }
}

extension LoginViewController: LoginUI {
    
    func updateActivityIndicator(show: Bool) {
        if activityIndicator.superview == nil {
            activityIndicator.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
            view.addSubview(activityIndicator)
        }
        
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showError(title: String, message: String) {
        presentAlert(title: title, message: message)
    }
}
