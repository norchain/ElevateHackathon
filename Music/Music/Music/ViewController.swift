//
//  ViewController.swift
//  Music
//
//  Created by Daniel Pan on 2018-09-22.
//  Copyright © 2018 geekmouse. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        let strUrl = "https://api.7digital.com/1.2/artist/search?shopId=2020&oauth_consumer_key=7d4vr6cgb392&q=taylor"
        
        let url = URL(string: strUrl)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Accept", forHTTPHeaderField: "application/json")
        
        let task = session.dataTask(with: request){ data, response, error in
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            print("gotten json response dictionary is \n \(json)")
    
        }
        
        
        
        // execute the HTTP request
        task.resume()
        // Do any additional setup after loading the view.

    }


    
}

