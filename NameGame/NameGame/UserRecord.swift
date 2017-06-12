//
//  UserRecord.swift
//  NameGame
//
//  Created by Tammy Le on 6/12/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

/** 
    Models an error that's thrown if key can't be parsed from JSON dictionary.
 */
enum ParsingError: Error {
    case missingKey(String)
}

/** 
    Models a user record.
 */

struct UserRecord {
    
    let id: String
    let firstName: String
    let lastName: String
    let imageUrl: String
    
    // Initializer given dictionary.
    init(dict: [String: Any]) throws {
        guard
            let id = dict[JSONKey.id.rawValue] as? String else
        {
            throw ParsingError.missingKey(JSONKey.id.rawValue)
        }
        guard
            let firstName = dict[JSONKey.firstName.rawValue] as? String else
        {
            throw ParsingError.missingKey(JSONKey.firstName.rawValue)
        }
        guard let lastName = dict[JSONKey.lastName.rawValue] as? String else
        {
            throw ParsingError.missingKey(JSONKey.lastName.rawValue)
        }
        guard
            let headshotDict = dict[JSONKey.headshot.rawValue] as? [String:Any] else
        {
            throw ParsingError.missingKey(JSONKey.headshot.rawValue)
        }
        guard
            let imageUrl = headshotDict[JSONKey.url.rawValue] as? String else
        {
            throw ParsingError.missingKey(JSONKey.url.rawValue)
        }
        self.init(
            id: id,
            firstName: firstName,
            lastName: lastName,
            imageUrl: imageUrl
        )
    }
    
    // Private initializer
    private init(id: String, firstName: String, lastName: String, imageUrl: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageUrl = imageUrl
    }
    
}
