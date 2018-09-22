//
//  MaskedRelatedCreditCardAccount.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import ObjectMapper

enum AccountType: String {
    case visa
    case master
}

class MaskedRelatedCreditCardAccount: Mappable {
    var accountId: String?
    var accountType: AccountType?
    var maskedAccountNumber: String?
    
    required init?(map: Map) {
        
    }
    
    // Mark: - mappable
    func mapping(map: Map) {
        accountId   <- map["accountId"]
        accountType <- map["accountType"]
        maskedAccountNumber <- map["maskedAccountNumber"]
    }
}
