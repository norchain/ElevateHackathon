//
//  HTTPService.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-21.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol HTTPServiceProtocol {
    func getAllUsers(complete: @escaping UsersCompleteHandler)
    func getCustomerBy(id: String, complete: @escaping UserCompleteHandler)
}

enum HTTPResult<U>
{
    case Success(result: U)
    case Failure(error: HTTPError)
}

enum HTTPError: Error {
    case generic
    case invalidURL
    case fetchUser
    case parseJson
}

typealias UsersCompleteHandler = (HTTPResult<[User]>) -> Void
typealias UserCompleteHandler = (HTTPResult<User>) -> Void


class HTTPService: HTTPServiceProtocol {

    let headers: HTTPHeaders = [
        "Authorization": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJDQlAiLCJ0ZWFtX2lkIjoiNzdhMzQ0OTUtYTYwNS0zNjVhLWE3YmYtZTk2NDU1YWY5ZDY0IiwiZXhwIjo5MjIzMzcyMDM2ODU0Nzc1LCJhcHBfaWQiOiI4NjUzYjAyOC04MzY1LTQzNmMtOTM4Zi04NWM5OWZmMzFlNmUifQ.fZInef0tn0CmrO7uXNDilLuqotzgJm20-Kdn7kesTWI",
        "Content-Type": "application/json"
    ]
    
    func getAllUsers(complete: @escaping UsersCompleteHandler) {
        guard let url = URL(string: "https://api.td-davinci.com/api/virtual-customers") else {
            complete(.Failure(error: HTTPError.invalidURL))
            return
        }
        
        
        let parameters: Parameters = ["continuationToken":""]
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON(queue: utilityQueue) { (response) in
                guard response.result.isSuccess else {
                    print("Error fetching users")
                        complete(.Failure(error: HTTPError.fetchUser))
                    return
                }
                
                guard let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let dic = json?["result"] as? [String: Any],
                    let customers = dic["customers"] as? [[String: Any]] else {
                    complete(.Failure(error: HTTPError.fetchUser))
                    return
                }
                
                let users: [User] = customers.compactMap { json in
                    return User(JSON: json)
                }
                
                DispatchQueue.main.async {
                    complete(.Success(result: users))
                }
        }
    }
    
    func getCustomerBy(id: String, complete: @escaping UserCompleteHandler) {
        guard let url = URL(string: "https://api.td-davinci.com/api/customers/" + id) else {
            complete(.Failure(error: HTTPError.invalidURL))
            return
        }
        
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON(queue: utilityQueue) { (response) in
                guard response.result.isSuccess else {
                    print("Error fetching users")
                    complete(.Failure(error: HTTPError.fetchUser))
                    return
                }
                
                guard let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let dic = json?["result"] as? [String: Any] else {
                        complete(.Failure(error: HTTPError.fetchUser))
                        return
                }
                
                guard let user: User = User(JSON: dic) else {
                    complete(.Failure(error: HTTPError.parseJson))
                    return
                }
                    
                DispatchQueue.main.async {
                    complete(.Success(result: user))
                }
                
        }
    }
}


