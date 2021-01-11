//
//  ProfileViewController.swift
//  AnApp
//
//  Created by Rohan Ramsay on 7/01/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var lastLoginLabel: UILabel!
    
    var presenter: ProfilePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.uiDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        presenter.logout()
    }
}

extension ProfileViewController: ProfileUI {
    func showError(title: String, message: String) {
        presentAlert(title: title, message: message)
    }
    
    func show(name: String, email: String, phone: String, lastLogin: String) {
        nameLabel.text = name
        emailLabel.text = email
        phoneLabel.text = phone
        lastLoginLabel.text = lastLogin
    }
}
