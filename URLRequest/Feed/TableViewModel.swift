//
//  TableViewModel.swift
//  URLRequest
//
//  Created by Наталья Булгакова on 30.03.2022.
//

import UIKit

class TableViewModel {
    
    var dataSource = [TableItem]()
    
    var reloadData: (() -> Void)?
    
    private let pageSize = 10
    
    private var searchText = "Bulgakov"
    private var page = 1
    private var pageCount = 0
    
    private let newsFetcher: NewsFetcher
    
    init(newsFetcher: NewsFetcher) {
        self.newsFetcher = newsFetcher
    }
    
    func didLoadView() {
        getNews()
    }
    
    func willDisplaySell(at index: Int){
        guard index == dataSource.count - 5 else { return }
        page += 1
        guard page <= pageCount else { return }
        getNews()
    }
    
    func searchByText(_ text:String?){
        searchText = text ?? ""
        page = 1
        dataSource.removeAll()
        getNews()
    }
    
    func getNews(){
        newsFetcher.getNews(searchText: searchText, page: page, pageSize: pageSize) { [weak self] result in
            switch result {
            case .success(let news):
                guard let self = self else { return } //???
                self.pageCount = news.totalResults / self.pageSize
                if news.totalResults % self.pageSize != 0 {
                        self.pageCount += 1
                }
                self.fillDataSourse(news: news)
                print("TableViewModel getNews for page \(self.page) pageCount \(self.pageCount)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fillDataSourse(news: News) {
        for article in news.articles {
            dataSource.append(TableItem(tableItemImage: "news", tableItemName: article.title))
        }
        reloadData?()
    }
}
