//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation

protocol NameGameDelegate: class {
    func complete() -> Void
}

class NameGame {
    weak var delegate: NameGameDelegate?
    
    // Collections for profile data
    var profiles: [Coworkers] = [Coworkers]()
    var headshots: [Headshot] = [Headshot]()
    let numberPeople = 6
    
    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        if let url: URL = URL(string: Constants.profilesEndpoint) {

            //weak var blockSelf: NameGame? = self
            let task = URLSession.shared.dataTask(with: url) { (data: Data?, resp: URLResponse?, error: Error?) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        do {
                            if let jsonArray: [Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any] {
                                let decoder = JSONDecoder()
                                for item in jsonArray {
                                    let data = try JSONSerialization.data(withJSONObject: item, options: [])
                                    let coworker: Coworkers = try decoder.decode(Coworkers.self, from: data)
                                    // Add coworker to collection
                                }
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
