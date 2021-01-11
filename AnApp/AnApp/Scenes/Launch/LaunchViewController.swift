//
//  LaunchViewController.swift
//  AnApp
//
//  Created by Rohan Ramsay on 7/01/21.
//

import UIKit

class LaunchViewController: UIViewController {

    var presenter: LaunchPresenter!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.uiDidLoad()
    }
}

