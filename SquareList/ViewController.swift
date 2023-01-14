//
//  ViewController.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 13.01.2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private var tableView: UITableView = UITableView()
    private var messageLable: UILabel = UILabel()
    private var viewModel: ViewModel
    private var dataSource: UITableViewDiffableDataSource<Section, Employee>!
    private var cancelables = Set<AnyCancellable>()
    
    init(viewMdoel: ViewModel) {
        self.viewModel = viewMdoel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: "EmployeeCell")
        
        configureDataSource()
        
        view.addSubview(messageLable)
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLable.leftAnchor.constraint(equalTo: view.leftAnchor),
            messageLable.topAnchor.constraint(equalTo: view.topAnchor),
            messageLable.rightAnchor.constraint(equalTo: view.rightAnchor),
            messageLable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        messageLable.numberOfLines = 0
        messageLable.isHidden = true
                
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:  { [unowned self] state in
            switch state {
            case let .content(employees):
                messageLable.isHidden = true
                var snapshot = dataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([.main])
                snapshot.appendItems(employees)
                self.dataSource.apply(snapshot)
            case let .error(message):
                messageLable.isHidden = false
                messageLable.text = message
            case .loading:
                messageLable.isHidden = true
                return //?
            }
        }).store(in: &cancelables)
        
        viewModel.reload()
        
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Employee>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, employee: Employee) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
            cell.configure(employee: employee)
            return cell
        }
    }
}

