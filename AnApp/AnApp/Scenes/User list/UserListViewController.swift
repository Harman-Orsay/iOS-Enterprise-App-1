//
//  ViewController.swift
//  CodeChallenge1
//
//  Created by Rohan Ramsay on 21/10/20.
//  Copyright © 2020 Harman Orsay. All rights reserved.
//

import UIKit
import Combine
import AnAppKit
import AnAppUIKit

enum UserListViewAction {
    case initial
    case add(AddUserResponder)
    case sort(SortFieldSelectionResponder, User.SortableField)
    case list
    case dismiss
}

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
    
    var subscriptions = Set<AnyCancellable>()
    var presenter: UserListPresenter!
    var viewModel: UserListViewModel!
    var viewControllerFactory: UserListViewControllerFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        
        setupTableView()
        setupBindings()
        fetchMore()
    }
    
    @IBAction func actionAddButton(_ sender: Any) {
        viewModel.actionAdd()
    }
    
    @IBAction func actionList(_ sender: Any) {
        viewModel.actionList()
    }
    
    func fetchMore() {
        if case .loading = (tableView.tableFooterView as? LoadingIndicatorTableHeaderFooterView)?.state {return}
        tableView.tableFooterView = self.loadingFooter
        loadingFooter.state = .loading
        tableView.scrollToBottom()
        
        //TODO: - cannot be unit tested - break it into footer state variable & put it in view model
        viewModel.fetchMore()
            .sink(receiveCompletion: { [unowned self]
                completion in
                switch completion {
                case .finished:
                    self.loadingFooter.state = .completed(message: nil)
                    self.tableView.tableFooterView = nil
                case .failure(let error):
                    self.loadingFooter.state = .completed(message: error.localizedDescription)
                }
            }, receiveValue: {_ in})
            .store(in: &subscriptions)
    }
    
    func toggleActivityIndicator(show: Bool) {
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
    
    func process(viewAction: UserListViewAction){
        switch viewAction {
        case .initial: break
        case .add(let responder): showAddUser(responder: responder)
        case .sort(let responder, let currentSortField): showSortList(responder: responder, currentSortField: currentSortField)
        case .list: showListActions()
        case .dismiss: presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension UserListViewController {
    func showAddUser(responder: AddUserResponder) {
        present(viewControllerFactory.makeAddUserNavigationController(),
                animated: true,
                completion: nil)
    }
    
    func showSortList(responder: SortFieldSelectionResponder, currentSortField: User.SortableField) {
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
            viewModel.actionSort()
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
    
    func setupBindings() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink{ [unowned self] _ in
                tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$viewAction
            .receive(on: DispatchQueue.main)
            .sink{ [unowned self] action in
                process(viewAction: action)
            }
            .store(in: &subscriptions)
        
        viewModel.$activityInprogress
            .receive(on: DispatchQueue.main)
            .sink{ [unowned self] state in
                toggleActivityIndicator(show: state)
            }
            .store(in: &subscriptions)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] error in
                presentAlert(title: error.title, message: error.message)
            }
            .store(in: &subscriptions)
    }
}

protocol UserListUI: UI {
    func updateActivityIndicator(show: Bool)
    func showError(title: String, message: String)
    func show(users: [User])
    func perform(action: UserListViewAction)
    func updateLoadMoreActivityIndicator(state: LoadingIndicatorTableHeaderFooterView.State)
}

class UserListPresenter: Presenter {
    func uiDidLoad() {
        
    }
    
    var ui: UserListUI!
    var useCaseFactory: UserUseCaseFactory
    
    init(factory: UserUseCaseFactory) {
        self.useCaseFactory = factory
    }
}

extension UserListPresenter: AddUserResponder {
    func canceled() {
        
    }
    
    func created(user: User) {
        
    }
}

extension UserListPresenter: SortFieldSelectionResponder {
    func selected(field: User.SortableField) {
        
    }
}
