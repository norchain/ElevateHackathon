//
//  HistoryViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    var purchases: [Restaurant] = [] {
        didSet {
            tableview.reloadData()
        }
    }
    
    var selected: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.registerCellTypes([UserTableViewCell.self])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let accountsData = UserDefaults.standard.data(forKey: "Purchase"),
            let rests = try? JSONDecoder().decode([Restaurant].self, from: accountsData) {
            purchases = rests
        }
    }

}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellType, for: indexPath)
        if let cell = cell as? UserTableViewCell {
            cell.configure(with: purchases[indexPath.row])
        }
        
        return cell
    }
    
    
}
