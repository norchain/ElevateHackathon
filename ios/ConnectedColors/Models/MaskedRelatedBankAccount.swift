//
//  MaskedRelatedBankAccounts.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import ObjectMapper

class MaskedRelatedBankAccount: Codable, Mappable {
    var branchNumber: String?
    var maskedAccountNumber: String?
    var accountId: String?
    
    
    required init?(map: Map) {
        
    }
    
    // Mark: - mappable
    func mapping(map: Map) {
        branchNumber        <- map["branchNumber"]
        maskedAccountNumber <- map["maskedAccountNumber"]
        accountId           <- map["accountId"]
    }
}

