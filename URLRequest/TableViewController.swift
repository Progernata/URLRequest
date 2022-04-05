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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let viewModel: TableViewModel
    
    private let UrlRequestComponent: UrlRequestComponent
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var newsTitles = Array(repeating: "", count: 10) //костыль костыльный так как нужно инициализировать массив опред длины, я хз как еще это можно сделать
    
    init(viewModel: TableViewModel, UrlRequestComponent: UrlRequestComponent) {
        self.viewModel = viewModel
        self.UrlRequestComponent = UrlRequestComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
        setupNavBar()
        setupTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
    
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
   
    private func getNews() {
        
        UrlRequestComponent.searchNews(userCompletionHandler: { jsonNews, error in
            
            if let jsonNews = jsonNews {
                print("getNews Кол-во статей \(jsonNews.totalResults)")
                                
                for index in (0...jsonNews.articles.count-1) {
                    self.newsTitles[index] = jsonNews.articles[index].title
                }
                self.viewModel.fillDataSourse(newsTitles: self.newsTitles)
            }
        })
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
//MARK: UITableViewDataSource
extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("dataSource.count \(viewModel.dataSource.count) pageCount \(UrlRequestComponent.pageCount)")
        return viewModel.dataSource.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isLastSell(for: indexPath) { //если мы дошли до конца таблицы
            
            if  UrlRequestComponent.pageCount > 0 { //и у нас есть хотя бы одна страница выдачи
                
                if  UrlRequestComponent.currentPage < UrlRequestComponent.pageCount { //и если есть еще что подгрузить
                    
                    UrlRequestComponent.currentPage+=1 //тогда переходим на следующую стр и идем за контентом
                    getNews()
                    print("isLastSell currentPage \(UrlRequestComponent.currentPage)")
                
                }
            }
            print("isLastSell end table")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! TableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.setCellContent(imageName: viewModel.dataSource[indexPath.row].tableItemImage, labelText: viewModel.dataSource[indexPath.row].tableItemName)
    
        return cell
    }
    
}

extension TableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UrlRequestComponent.searchString = searchBar.text ?? ""
        viewModel.dataSource.removeAll()
        getNews()
    }
}

extension UITableView { //честно украдено

    func isLastSell(for indexPath: IndexPath) -> Bool {

        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1

        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
}
