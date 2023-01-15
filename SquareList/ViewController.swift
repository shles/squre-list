//
//  ViewController.swift
//  SquareList
//
//  Created by Артeмий Шлесберг on 13.01.2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private var messageLable: UILabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: ViewModel
    private var dataSource: UITableViewDiffableDataSource<String, Employee>!
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
        
        title = "Square Emplyees"
        UIView.performWithoutAnimation {
            configureTableView()
            configureDataSource()
            configureMessageLabel()
            configureViewModel()
            configureRefreshControl()
        }
        
        
        self.viewModel.reload()
        
    }
    
    private func configureTableView() {
        
        
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: "EmployeeCell")
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        refreshControl.beginRefreshing()
        viewModel.reload()
    }
    
    private func configureMessageLabel() {
        view.addSubview(messageLable)
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            messageLable.topAnchor.constraint(equalTo: view.topAnchor),
            messageLable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            messageLable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        messageLable.numberOfLines = 0
        messageLable.textAlignment = .center
        messageLable.font = .preferredFont(forTextStyle: .body)
        messageLable.isHidden = true
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<String, Employee>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, employee: Employee) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
            cell.configure(employee: employee)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    private var firstLoad = true
    
    private func configureViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:  { [unowned self] state in
                self.refreshControl.endRefreshing()
                switch state {
                case let .content(employees):
                    messageLable.isHidden = true
                    var snapshot = dataSource.snapshot()
                    snapshot.deleteAllItems()
                    snapshot.appendSections(employees.keys.sorted())
                    for team in employees.sorted(by: {$0.key < $1.key}) {
                        snapshot.appendItems(team.value, toSection: team.key)
                    }
                    if firstLoad {
                        UIView.performWithoutAnimation {
                            self.dataSource.apply(snapshot)
                        }
                        firstLoad = false
                    } else {
                        self.dataSource.apply(snapshot)
                    }
                case let .error(message):
                    messageLable.isHidden = false
                    messageLable.text = message
                    var snapshot = dataSource.snapshot()
                    snapshot.deleteAllItems()
                    self.dataSource.apply(snapshot)
                }
            }).store(in: &cancelables)
    }
}
extension ViewController: UITableViewDelegate {
    
    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.snapshot().sectionIdentifiers[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = dataSource.snapshot().sectionIdentifiers[section]
        label.backgroundColor = .clear
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

