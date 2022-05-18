//
//  TableViewModel.swift
//  URLRequest
//
//  Created by Наталья Булгакова on 30.03.2022.
//

import UIKit

protocol TableViewModel {
    var reloadData: (() -> Void)? { get set }
    var emptyDataSource: (() -> Void)? { get set }
    var image: ((Int, Data) -> Void)? { get set }
    
    func didLoadView()
    func willDisplayCell(at index: Int)
    func searchByText(_ text:String?)
    
    func prefetchImage(for indexPaths: [IndexPath])
}

class TableViewModelImpl: TableViewModel {
    
    var dataSource = [TableItem]()
    
    var reloadData: (() -> Void)?
    var emptyDataSource: (() -> Void)?
    var image: ((Int, Data) -> Void)?
    
    private let pageSize = 10
    
    private var searchText = "May"
    private var page = 1
    private var pageCount = 0
    
    var articles: [Article] = []
    
    private let newsFetcher: NewsFetcher
    
    init(newsFetcher: NewsFetcher) {
        self.newsFetcher = newsFetcher
    }
    
    func didLoadView() {
        getNews()
    }
    
    func willDisplayCell(at index: Int) {
        guard index == dataSource.count - 5 else { return }
        page += 1
        guard page <= pageCount else { return }
        getNews()
    }
    
    func searchByText(_ text:String?) {
        searchText = text ?? ""
        page = 1
        dataSource.removeAll()
        getNews()
    }
    
    func prefetchImage(for indexPaths: [IndexPath]) {
        indexPaths.forEach {
            newsFetcher.downloadImageData(imageUrl: articles[$0.row].urlToImage) { [weak self] imageData in
                if let imageData = imageData {
                    self?.image?($0.row, imageData)
                }
            }
        }
    }
    
    private func getNews() {
        newsFetcher.getNews(searchText: searchText, page: page, pageSize: pageSize) { [weak self] result in
            switch result {
            case .success(let news):
                guard let self = self else { return } //???
                self.articles.append(contentsOf: news.articles)
                self.pageCount = news.totalResults / self.pageSize
                if news.totalResults % self.pageSize != 0 {
                        self.pageCount += 1
                }
                self.fillDataSourse(news: news)

                if news.totalResults == 0 {
                    self.emptyDataSource?()
                }
                print("TableViewModel getNews for page \(self.page) pageCount \(self.pageCount)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fillDataSourse(news: News) {
        for article in news.articles {
            self.dataSource.append(TableItem(tableItemName: article.title))
        }
        self.reloadData?()
    }
    
//    private func loadImages(news: News) {
//        for (index, article) in news.articles.enumerated() {
//            newsFetcher.downloadImageData(imageUrl: article.urlToImage) {
//                imageData in
//                if let imageData = imageData {
//                    
//                }
//            }
//        }
//    }
}
