//
//  ViewController.swift
//  CodeChallenge1
//
//  Created by Rohan Ramsay on 21/10/20.
//  Copyright © 2020 Harman Orsay. All rights reserved.
//

import UIKit
import AnAppKit
import AnAppUIKit
import WidgetKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var loadingFooter = LoadingIndicatorTableHeaderFooterView(frame: CGRect(origin: CGPoint.zero,
                                                                           size: CGSize(width: tableView.frame.width,
                                                                                        height: 44)))
    let activityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .large)
      indicator.hidesWhenStopped = true
      return indicator
    }()
    
    var presenter: UserListPresenter!
    var viewControllerFactory: UserListViewControllerFactory!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        WidgetCenter.shared.reloadTimelines(ofKind: AppGroupTarget.configurableWidget.widgetKind!)//temp to test refresh
        setupTableView()
        presenter.uiDidLoad()
        fetchMore()
    }
    
    @IBAction func actionAddButton(_ sender: Any) {
        presenter.actionAdd()
    }
    
    @IBAction func actionList(_ sender: Any) {
        presenter.actionList()
    }
    
    func fetchMore() {
        if case .loading = (tableView.tableFooterView as? LoadingIndicatorTableHeaderFooterView)?.state {return}
        tableView.tableFooterView = self.loadingFooter
        loadingFooter.state = .loading
        tableView.scrollToBottom()
        presenter.fetchMore()
    }
}

extension UserListViewController {
    func showAddUser() {
        present(viewControllerFactory.makeAddUserNavigationController(),
                animated: true,
                completion: nil)
    }
    
    func showSortList(currentSortField: User.SortableField) {
        present(viewControllerFactory.makeSortFieldsNavigationController(selectedField: currentSortField),
                animated: true,
                completion: nil)
    }
    
    func showListActions() {
        guard !tableView.isEditing else {
            tableView.isEditing = false
            return
        }
        
        let alert = UIAlertController(title: "List Actions", message: nil, preferredStyle: .actionSheet)
        let sortAction = UIAlertAction(title: "Sort Users", style: .default, handler: {
            [unowned self] _ in
            presenter.actionSort()
        })
        let deleteAction = UIAlertAction(title: "Delete Users", style: .default, handler: {
            [unowned self] _ in
            tableView.isEditing = true
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(sortAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}

extension UserListViewController {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = loadingFooter
    }
}

extension UserListViewController: UserListUI {
    func show(users: [User]) {
        self.users = users
        tableView.reloadData()
    }
    
    func perform(action: UserListViewAction){
        switch action {
        case .initial: break
        case .add: showAddUser()
        case .sort(let currentSortField): showSortList(currentSortField: currentSortField)
        case .list: showListActions()
        case .dismiss: presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func showError(title: String, message: String) {
        presentAlert(title: title, message: message)
    }
    
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
    
    func updateLoadMoreActivityIndicator(state: LoadingIndicatorTableHeaderFooterView.State) {
        self.loadingFooter.state = state
        
        if case .completed(_) = state {
            self.tableView.tableFooterView = nil
        }
    }    
}

protocol UserListViewControllerFactory {
    func makeAddUserNavigationController() -> UINavigationController
    func makeSortFieldsNavigationController(selectedField: User.SortableField) -> UINavigationController
}
