//
//  Address.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import ObjectMapper

class Address: Mappable {
    var streetName: String?
    var province: String?
    var streetNumber: String?
    var addressType: Int?
    var postalCode: String?
    var latitude: Double?
    var municipality: String?
    var longitude: Double?
    
    required init?(map: Map) {
        
    }
    
    // Mark: - mappable
    func mapping(map: Map) {
        streetName      <- map["streetName"]
        province        <- map["province"]
        streetNumber    <- map["streetNumber"]
        addressType     <- map["addressType"]
        postalCode      <- map["postalCode"]
        latitude        <- map["latitude"]
        municipality    <- map["municipality"]
        longitude       <- map["longitude"]
        
    }
    
    var desciption: String {
        return streetT + streetNT + proviceT + postcode
    }
    
    var streetT: String {
        return streetName ?? ""
    }
    
    var streetNT: String {
        return streetName ?? ""
    }
    
    var proviceT: String {
        return province ?? ""
    }
    
    var postcode: String {
        return postalCode ?? ""
    }
}
