//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

protocol NameGameDelegate: class {
}

enum FilterGameData {
    case all
    case former
    case current
    case custom(String)
}


class NameGame {

    weak var delegate: NameGameDelegate?

    let numberPeople = 6
    
    /// All game data from server.
    var allGameData: [[String:Any]] = []
    
    /// Referenceable game data.
    var gameData: [[String:Any]] = []
    
    /// Indexes to current gameData.
    var inPlayGameItems: [Int] = []
    
    /// Index of solution in gameData
    var inPlaySolutionItem: Int = 0


    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        let tempURL = URL.init(fileURLWithPath: NSTemporaryDirectory())
        let profilesURL = tempURL.appendingPathComponent("profiles")
        
        var dataFromResponse: Data? = nil
        
        do {
            let data = try Data(contentsOf: profilesURL)
            dataFromResponse = data
            print("read from disk")
        } catch {
            print(error)
        }
        
        
        do {
            if dataFromResponse == nil {
                let data = try Data(contentsOf: URL(string:"https://willowtreeapps.com/api/v1.0/profiles/")!)
                dataFromResponse = data
                do {
                    try data.write(to: profilesURL)
                } catch {
                    print(error)
                    
                }
            }
            
            let json = try JSONSerialization.jsonObject(with: dataFromResponse!, options: []) as! [String:Any]
            //print(json)
            
            processResults(json)
            
        } catch {
            print(error)
        }
        
        completion()


    }
    
    
    private func processResults(_ results:[String:Any]) {
        
        if let items = results["items"] as? [[String:Any]] {
            allGameData = items
        }
        analyzeGameData()
    }
    
    
    
    private func analyzeGameData() {
        
        print("Count \(gameData.count)")
        
        let formerEmployees = gameData.filter { $0["jobTitle"] == nil }
        
        print("FCount \(formerEmployees.count)")
        
        gameData = allGameData
        pickItems()
    }
    
    
    func filterGameData(filter: FilterGameData) {
        switch filter {
        case .all:
            gameData = allGameData

        default:
            gameData = allGameData
        }
        
    }
    
    func pickItems() {
        
        var alreadySelected = IndexSet()
        var selectedItems: [Int] = []
        
        let count = gameData.count
        
        // Pick candidates
        while (selectedItems.count < numberPeople) {
            let r = Int(arc4random_uniform(UInt32(count - 1)))
            
            if alreadySelected.contains(r) {
                print("duplicate")
                continue
            }
            alreadySelected.insert(r)
            selectedItems.append(r)
        }
        
        print("\(selectedItems)")
        
        inPlayGameItems = selectedItems
        
        // Pick solution item
        let r = Int(arc4random_uniform(UInt32(selectedItems.count - 1)))
        
        inPlaySolutionItem = inPlayGameItems[r]
        print("\(inPlaySolutionItem)")
        
        
        // testdata
        //        [21, 25, 71, 47, 96, 76]
        //        96
        
        inPlayGameItems = [21, 25, 71, 47, 96, 76]
        inPlaySolutionItem = 96
        
        
        //        print(Int(arc4random_uniform(UInt32(count ))))
        //        print(Int(arc4random_uniform(UInt32(count ))))
        //        print(Int(arc4random_uniform(UInt32(count ))))
        //        print(Int(arc4random_uniform(UInt32(count ))))
        
    }
    

    /// Returns the solution profile name.
    func getSolutionProfileName() -> String {
        return getProfileName(at: inPlaySolutionItem)
    }

    /// Returns the profile name at index.
    func getProfileName(at index:Int) -> String {
        
        var result = ""
        
        let profile = gameData[index]
        
        if let firstName = profile["firstName"] as? String {
            result = firstName
        }
        
        if let lastName = profile["lastName"] as? String {
            if result.isEmpty {
                result = lastName
                
            } else {
                result += " " + lastName
            }
        }
        
        return result
        
    }
    
    
    func getImage(at index:Int, completion: @escaping (UIImage) -> Void) {
        
        let profile = gameData[index]
        
        if let headShot = profile["headshot"] as? [String:Any],
            let headShotURLString = headShot["url"] as? String {
            
            
            if let imageURL = URL(string:"http:" + headShotURLString) {
                print(headShotURLString)
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageURL),
                        let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                } // dispatch
                
            }
            
        }
        print(profile)
    }

}


/*
 firstName = Joel;
 headshot =             {
 alt = "headshot joel garrett";
 height = 340;
 id = 4Mv2CONANym46UwuuCIgK;
 mimeType = "image/jpeg";
 type = image;
 url = "//images.contentful.com/3cttzl4i3k1h/4Mv2CONANym46UwuuCIgK/cbeb43c93a843a43c07b1de9954795e2/headshot_joel_garrett.jpg";
 width = 340;
 };
 id = 4NCJTL13UkK0qEIAAcg4IQ;
 jobTitle = "Senior Software Engineer";
 lastName = Garrett;
 slug = "joel-garrett";
 socialLinks =             (
 );
 type = people;
 },
 {
 firstName = Gregg;
 headshot =             {
 alt = "headshot gregg carrier";
 height = 726;
 id = 2CQgvecTcoSUqy6o4qcCwi;
 mimeType = "image/jpeg";
 type = image;
 url = "//images.contentful.com/3cttzl4i3k1h/2CQgvecTcoSUqy6o4qcCwi/c4a0610db37e6f34b8968275fb32a1b9/IMG_4495-348.jpg";
 width = 726;
 };
 
 */


