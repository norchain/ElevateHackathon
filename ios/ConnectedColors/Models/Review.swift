//
//  Review.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import ObjectMapper

class Review: Mappable {
    var client_id: String?
    var td_account: String?
    var stars: String?
    var comment: String?
    
    required init?(map: Map) {
        
    }
    
    // Mark: - mappable
    func mapping(map: Map) {
        client_id       <- map["client_id"]
        td_account      <- map["td_account"]
        stars           <- map["stars"]
        comment         <- map["comment"]
    }
}
