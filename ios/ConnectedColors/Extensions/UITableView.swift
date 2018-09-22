//
//  UITableView.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCellTypes(_ types: [BaseTableViewCell.Type]) {
        types.forEach {
            guard $0.hasNib else { return register($0, forCellReuseIdentifier: $0.cellType) }
            register(UINib(nibName: $0.cellType, bundle: nil), forCellReuseIdentifier: $0.cellType)
        }
    }
    
    func reload(_ rows: [Int], section: Int = 0, rowAnimation: UITableViewRowAnimation = .fade) {
        let paths = rows.map { IndexPath(row: $0, section: section) }
        beginUpdates()
        reloadRows(at: paths, with: rowAnimation)
        endUpdates()
    }
}
