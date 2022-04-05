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
    
    func fillDataSourse(newsTitles: [String]) {

        for title in newsTitles {
            dataSource.append(TableItem(tableItemImage: "news", tableItemName: title))
        }
        reloadData?()
    }
}
