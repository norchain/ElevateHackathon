//
//  User.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import ObjectMapper

enum Gender: String {
    case Male
    case Female
    
}

enum UserType: String {
    case Personal
}

enum WorkType: String {
    case parttime
    case fulltime
}

enum Marriage: String {
    case Single
    case Widowed
    case Married
    case Separated
    case Divorced
}

class User: Mappable {
    var id: String?
    var type: String?
    var giveName: String?
    var otherName: String?
    var maidenName: String?
    var age: Int?
    var gender: Gender?
    var birthDate: String?
    var workActivity: WorkType?
    var occupationIndustry: String?
    var totalIncome: Double?
    var relationshipStatus: Marriage?
    var addresses: [String: Address]?
    var maskedRelatedBankAccounts: [String: [MaskedRelatedBankAccount]]?
    var maskedRelatedCreditCardAccounts: [String: [MaskedRelatedCreditCardAccount]]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        type            <- map["type"]
        giveName        <- map["givenName"]
        maidenName      <- map["maidenName"]
        age             <- map["age"]
        gender          <- map["gender"]
        birthDate       <- map["birthDate"]
        workActivity    <- map["workActivity"]
        occupationIndustry  <- map["occupationIndustry"]
        totalIncome     <- map["totalIncome"]
        relationshipStatus  <- map["relationshipStatus"]
        addresses         <- map["addresses"]
        maskedRelatedBankAccounts   <- map["maskedRelatedBankAccounts"]
        maskedRelatedCreditCardAccounts <- map["maskedRelatedCreditCardAccounts"]
        id              <- map["id"]
    }
}
