//
//  RestaurantWorker.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation


class RestaurantWorker {
    var service: RestaurantProtocol
    
    init(service: RestaurantProtocol) {
        self.service = service
    }
    
    func getAllRestaurants(complete: @escaping RestaurantsHandler) {
        service.getAllRestaurants(complete: complete)
    }
    
    func rate(client_id: String, td_account: String, stars: String, comment: String, complete: @escaping rateHandler) {
        service.rate(client_id: client_id, td_account: td_account, stars: stars, comment: comment, complete: complete)
    }
}
