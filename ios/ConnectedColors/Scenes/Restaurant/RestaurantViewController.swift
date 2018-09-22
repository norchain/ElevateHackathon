//
//  RestaurantViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import JGProgressHUD

class RestaurantViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    var worker: RestaurantWorker = RestaurantWorker(service: RestaurantService())
    
    var restaurants: [Restaurant] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.registerCellTypes([UserTableViewCell.self])

        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        worker.getAllRestaurants { (result) in
            switch result {
            case .Success(let restaurants):
                self.restaurants = restaurants
            case .Failure(let error):
                let alert = UIAlertController(title: "Something goes wrong: \(error.localizedDescription)", message: "please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
            hud.dismiss()
        }
    }
    

}

extension RestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Purchase?", message: "Buy the food", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Buy", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
            
            let rests = self.restaurants[indexPath.row]
            
            var total: [Restaurant] = []
            
            total.append(rests)
            
            if let accountsData = UserDefaults.standard.data(forKey: "Purchase"),
                let rests = try? JSONDecoder().decode([Restaurant].self, from: accountsData) {
                total.append(contentsOf: rests)
            }
            
            if let data = try? JSONEncoder().encode(total) {
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Purchasing..."
                hud.show(in: self.view)
                
                UserDefaults.standard.set(data, forKey: "Purchase")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    hud.dismiss()
                    
                    
                    let alertvc = UIAlertController(title: "Success!", message: "Your food is on the way", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertvc.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                })
                
            }
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (_) in
                
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension RestaurantViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellType, for: indexPath)
        if let cell = cell as? UserTableViewCell {
            cell.configure(with: restaurants[indexPath.row])
        }
        
        return cell
    }
    
    
}
