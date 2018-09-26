//
//  ProfileImageService.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

class ProfileImageService {
    private static var theInstance: ProfileImageService?
    
    // collection to store fetched images, can reduce time to fetch future images
    private var profileImages: [String: UIImage] = [String: UIImage]()
    
    public static func instance() -> ProfileImageService {
        if self.theInstance == nil {
            theInstance = ProfileImageService()
        }
        return theInstance!
    }
    
    // Assume existence of image for now/might need to change later
    func getImage(profileId: String) -> UIImage? {
        return profileImages[profileId]
    }
    
    func fetchImage(profileId: String, url: URL, completion: @escaping () -> Void) {
        guard self.profileImages[profileId] == nil else { return }

        do {
            let urlString: String = "https:" + "\(url)"
            if let fullUrl: URL = URL(string: urlString) {
                let imgData: Data = try Data(contentsOf: fullUrl)
                if let fetchedImage: UIImage = UIImage(data: imgData) {
                    self.profileImages[profileId] = fetchedImage
                }
                completion()
            }
        } catch let error {
            print(error.localizedDescription)
            completion()
        }
    }
}
