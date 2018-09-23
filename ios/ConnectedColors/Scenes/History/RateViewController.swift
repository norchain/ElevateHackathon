//
//  RateViewController.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit
import Cosmos

class RateViewController: UIViewController {
    @IBOutlet weak var ratingView: CosmosView!
    
    var worker = RestaurantWorker(service: RestaurantService())
    
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ratingView.settings.updateOnTouch = true
        
        ratingView.didTouchCosmos =  { rate in
            let client = self.restaurant?._id ?? ""
            let td = self.restaurant?.TD_account ?? ""
            let r = "\(rate)"
            let comment = ""
            self.worker.rate(client_id: client, td_account: td, stars: r, comment: comment, complete: { (review) in
                
            })
        }
    }
    
}
