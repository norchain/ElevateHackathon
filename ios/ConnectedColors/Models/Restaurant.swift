//
//  Restaurant.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import ObjectMapper

class Restaurant: Mappable {
    var _id: String?
    var name: String?
    var description: String?
    var price: String?
    var TD_account: String?
    
    required init?(map: Map) {
        
    }
    
    // Mark: - mappable
    func mapping(map: Map) {
        _id         <- map["_id"]
        name        <- map["name"]
        description <- map["description"]
        price       <- map["price"]
        TD_account  <- map["TD_account"]
    }
}
