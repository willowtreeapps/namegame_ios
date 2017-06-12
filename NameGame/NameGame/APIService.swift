//
//  APIService.swift
//  NameGame
//
//  Created by Tammy Le on 6/12/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

/**
    Reads and models data from online API.
 */

class APIService {
    
    static let manager = APIService()
    
    // Url for user records API
    let apiString: String = "https://willowtreeapps.com/api/v1.0/profiles/"
    
    // Load data from JSON file into a list of UserRecord objects.
    func loadData(completion: @escaping ([UserRecord]) -> Void) {
        
        let url = URL(string: apiString)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Couldn't create shared session.")
                return
            }
            
            do {
                // retrieve JSON dictionary {"results": [...]}
                if
                    let entries = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let items = entries[JSONKey.items.rawValue] as? [[String: Any]]
                {
                    
                    let userRecords: [UserRecord] = items.flatMap { dictionary in
                        if let record = try? UserRecord(dict: dictionary) {
                            return record
                        } else {
                            print("\(dictionary)")
                            return nil
                        }
                    }
                    completion(userRecords)
                } else
                {
                    completion([])
                }
                
            } catch {
                print("Error parsing results: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }
}
