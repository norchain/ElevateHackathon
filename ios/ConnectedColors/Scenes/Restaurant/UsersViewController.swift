//
//  RestaurantViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController {
    
    var worker: RestaurantWorker = RestaurantWorker(http: HTTPService())
    
    var users: [User] = []
    
    var filterUsers: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var error: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCellTypes([UserTableViewCell.self])
        

        worker.getUsers { [weak self] (result) in
            switch result {
            case .Success(let users):
                self?.users = users
                self?.filterUsers = users
            case .Failure(let error):
                self?.error = error.localizedDescription
            }
        }
    }
    
    func registerCellTypes(_ types: [BaseTableViewCell.Type]) {
        tableView.registerCellTypes(types)
    }
    
    // data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserTableViewCell.cellHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellType, for: indexPath)
        if let cell = cell as? UserTableViewCell {
            cell.configure(with: filterUsers[indexPath.row])
        }
        
        return cell
    }
    
}
