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
}
