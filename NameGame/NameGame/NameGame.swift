//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

/**
 A Game starts with a subset of all data
 Consists of multiple rounds using that same data
 */
import Foundation
import UIKit

protocol NameGameDelegate: class {
    func nameGameGameReady(_ controller: NameGame)
    func nameGameRoundReady(_ controller: NameGame)
}


/// Game state and data.
class NameGame {

    enum FilterGameData {
        case all
        case former
        case current
        case custom(String)
    }

    weak var delegate: NameGameDelegate?

    /// Number of people per round.
    let numberPeople = 6
    
    /// All game data from server.
    private var allGameData: [[String:Any]] = []
    
    /// Referenceable game data.
    private var gameData: [[String:Any]] = []
    
    /// Index of solution in gameData.
    private var inPlaySolutionItem: Int = 0

    /// Indexes to current gameData.
    var inPlayGameItems: [Int] = []

    /// Current round.
    var round = 0

    /// Game filter to use for new games.
    var gameFilter = FilterGameData.current

    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let profilesURL = tempURL.appendingPathComponent("profiles")
        print(tempURL.absoluteString)
        
        var dataFromResponse: Data? = nil
        
        // try disk file first
        do {
            let data = try Data(contentsOf: profilesURL)
            dataFromResponse = data
            print("read from disk")
        } catch {
            print(error)
        }
        
        
        do {
            if dataFromResponse == nil {
                // No disk file retrieve from server
                let data = try Data(contentsOf: URL(string:"https://willowtreeapps.com/api/v1.0/profiles/")!)
                dataFromResponse = data
                do {
                    try data.write(to: profilesURL)
                } catch {
                    print(error)
                    
                }
            }
            
            let json = try JSONSerialization.jsonObject(with: dataFromResponse!, options: []) as! [String:Any]
            
            processResults(json)
            
        } catch {
            print(error)
        }
        
        completion()

    }
    
    /// Process the results retrieving profiles.
    private func processResults(_ results:[String:Any]) {
        if let items = results["items"] as? [[String:Any]] {
            allGameData = items
        }
    }
    
 
    /// Starts a new game.
    func newGame() {
        filterGameData(filter: gameFilter)
        round = 0
        delegate?.nameGameGameReady(self)
    }
    
    /// Filters the actve gameData.
    func filterGameData(filter: FilterGameData) {
        
        switch filter {
        case .all:
            gameData = allGameData

        case .former:
            gameData = allGameData.filter { $0["jobTitle"] == nil }

        case .current:
            gameData = allGameData.filter { $0["jobTitle"] != nil }

        case .custom (let filterString):
            gameData = allGameData.filter { item in
                // use current with filter
                if item["jobTitle"] != nil {
                    if let firstName = item["firstName"] as? String {
                        if firstName.hasPrefix(filterString) {
                            return true
                        }
                    }
                }
                return false
            }
        }
        
        print("gameData Count \(gameData.count)")

    }

    /// Returns game title from filter.
    func gameTitle() -> String {
        switch gameFilter {
        case .all:
            return "All"
        case .former:
            return "Former"
        case .current:
            return "Current"
        case .custom (let filterString):
            return "Custom " + filterString
        }
    }
    
    /// Setup new round of current game.
    func newRound() {
        round += 1
        pickItems()
        delegate?.nameGameRoundReady(self)
    }
    
    /// Pick gamePlay items.
    private func pickItems() {
        
        var alreadySelected = IndexSet()
        var selectedItems: [Int] = []
        
        let count = gameData.count
        
        // Pick candidates
        while (selectedItems.count < numberPeople) {
            let r = Int(arc4random_uniform(UInt32(count - 1)))

            // check for duplicates
            if alreadySelected.contains(r) {
                continue
            }
            
            // check for valid only records with image
            if let _ = getImageURL(at: r) {
                alreadySelected.insert(r)
                selectedItems.append(r)
            }
        }
        
        inPlayGameItems = selectedItems
        
        // Pick solution item
        let r = Int(arc4random_uniform(UInt32(selectedItems.count - 1)))
        
        inPlaySolutionItem = inPlayGameItems[r]
    }
    
    
    /// Returns whether choice is correct
    func choiceResult(choiceIndex: Int) -> Bool {
        return choiceIndex == inPlaySolutionItem
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
    

    /// Obtain the image url for profile at index
    func getImageURL(at index:Int) -> URL? {
        
        let profile = gameData[index]
        
        if let headShot = profile["headshot"] as? [String:Any],
            let headShotURLString = headShot["url"] as? String {
            return URL(string:"http:" + headShotURLString)
        }

        return nil
    }

    
    /// Obtain the image for profile at index.
    func getImage(at index:Int, completion: @escaping (UIImage) -> Void) {
        
        if let imageURL = getImageURL(at: index) {
            
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                    let image = UIImage(data: imageData) {
                    completion(image)
                }
            }
        } 
    }

}



