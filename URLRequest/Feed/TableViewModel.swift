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
    
    private var searchText: String = "2022"
    private var page: Int = 0
    private var pageSize: Int = 10
    private var pages: Int = 0
    
    private let newsFetcher: NewsFetcher
    
    init(newsFetcher: NewsFetcher) {
        self.newsFetcher = newsFetcher
    }
    
    func didLoadView() {
        getNews()
    }
    
    func willDisplay(at index: Int) {
        guard index == dataSource.count - 5 else { return }
        page += 1
        if page == 1 { page += 1 }
        guard page < pages else { return }
        getNews()
    }
    
    func getNews() {
        print("new page \(page)  of \(pages)")
        newsFetcher.getNews(text: searchText, page: page, pageSize: pageSize) { [weak self] result in
            switch result {
            case .success(let news):
                guard let self = self else { return }
                self.pages = news.totalResults / self.pageSize
                if self.page > 0 {
                    if news.totalResults % self.page != 0 {
                        self.pages += 1
                    }
                }
                self.fillDataSourse(news: news)
                self.reloadData?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func serchText(_ text: String?) {
        searchText = text ?? ""
        page = 0
        dataSource.removeAll()
        getNews()
    }
    
    private func fillDataSourse(news: News) {

        for article in news.articles {
            let item = TableItem(tableItemImage: "news", tableItemName: article.title)
            dataSource.append(item)
        }
        reloadData?()
    }
}
