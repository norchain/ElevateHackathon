//
//  RestaurantViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class RestaurantViewController: UITableViewController {
    
    var worker: RestaurantWorker = RestaurantWorker(http: HTTPService())
    
    var users: [User] = []
    
    var error: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        worker.getUsers { [weak self] (result) in
            switch result {
            case .Success(let users):
                self?.users = users
            case .Failure(let error):
                self?.error = error.localizedDescription
            }
        }
    }

}
