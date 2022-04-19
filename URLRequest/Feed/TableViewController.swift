//
//  TableViewController.swift
//  URLRequest
//
//  Created by Наталья Булгакова on 30.03.2022.
//

import UIKit

class TableViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.rowHeight = 140
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let viewModel: TableViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(viewModel: TableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didLoadView()
        setupNavBar()
        setupTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
    
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.backgroundView = .none
            }
        }
        viewModel.emptyDataSource = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.backgroundView = UIImageView(image: UIImage(named: "empty"))
            }
        }
    }
}

private extension TableViewController {
    func setupNavBar() {
        navigationItem.title = "Table"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! TableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.setCellContent(imageName: viewModel.dataSource[indexPath.row].tableItemImage, labelText: viewModel.dataSource[indexPath.row].tableItemName)
    
        return cell
    }
    
}

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplaySell(at: indexPath.row)
    }
}

extension TableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchByText(searchBar.text)
    }
}


