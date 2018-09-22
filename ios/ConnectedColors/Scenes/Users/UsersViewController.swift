//
//  RestaurantViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import JGProgressHUD
import ViewAnimator

class UsersViewController: UITableViewController {
    
    var worker: UserWorker = UserWorker(http: HTTPService())
    
    var users: [User] = []
    
    var filterUsers: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var error: String = ""
    
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCellTypes([UserTableViewCell.self])
        let cells = tableView.visibleCells(in: 0)
        let zoom = AnimationType.zoom(scale: 0.5)
        let top = AnimationType.from(direction: .top, offset: 30.0)
        UIView.animate(views: cells, animations: [zoom, top])
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        worker.getUsers { [weak self] (result) in
            switch result {
            case .Success(let users):
                self?.users = users
                self?.filterUsers = users
            case .Failure(let error):
                self?.error = error.localizedDescription
                
            }
            
            hud.dismiss(animated: true)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = filterUsers[indexPath.row]
        
        performSegue(withIdentifier: "toTransfer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTransfer") {
            let vc = segue.destination as! TransferViewController
            vc.user = self.selectedUser
        }
    }
}
