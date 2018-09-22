//
//  Transfer.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import ObjectMapper

class Transfer: Mappable {
    var amount: Int?
    var creditTransactionID: String?
    var currency: String?
    var debitTransactionID: String?
    var fromAccountId: String?
    var id: String?
    var merchantId: String?
    var receipt: String?
    var toAccountId: String?
    var transactionTime: String?
    var transactionType: String?
    
    required init?(map: Map) {
        
    }
    
    // Mark: - mappable
    func mapping(map: Map) {
        amount          <- map["amount"]
        creditTransactionID <- map["creditTransactionID"]
        currency        <- map["currency"]
        debitTransactionID  <- map["debitTransactionID"]
        fromAccountId       <- map["fromAccountId"]
        id              <- map["id"]
        merchantId      <- map["merchantId"]
        receipt         <- map["receipt"]
        toAccountId     <- map["toAccountId"]
        transactionTime <- map["transactionTime"]
        transactionType <- map["transactionType"]
    }
}

