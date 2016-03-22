//
//  FaceButton.swift
//  NameGame
//
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

public class FaceButton: UIButton {

    var id: Int = 0
    var tintView: UIView?

    func loadImageFromURL(url url:String) {
        guard let imageURL = NSURL(string: url)
            else {
                preconditionFailure("Invalid image link")
            }
        NSURLSession.sharedSession().dataTaskWithURL(imageURL, completionHandler: { (data, response, error) -> Void in
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.setBackgroundImage(image, forState: .Normal)
            }
        }).resume()
    }

    public override func layoutSubviews() {
        if let tintView = self.tintView {
            tintView.frame = self.bounds
        }

        super.layoutSubviews()
    }

    func animateDisplayName() {
        self.setTitleColor(.whiteColor(), forState: .Normal)
        UIView.animateWithDuration(0.5, animations: {
            self.titleLabel?.alpha = 1.0
        })
    }

    func hideName() {
        setTitleColor(.clearColor(), forState: .Normal)
        self.titleLabel!.alpha = 0.0
    }



    func addTint(color: UIColor) {
        if self.tintView == nil {
            let tintView = UIView(frame: self.bounds)
            tintView.alpha = 0.0
            tintView.backgroundColor = color
            self.addSubview(tintView)
            self.addSubview(self.titleLabel!)
            self.tintView = tintView
        }

        UIView.animateWithDuration(0.5, animations: {
            self.tintView!.alpha = 0.3
        })
    }

    func removeTint() {
        if let tintView = self.tintView {
            tintView.removeFromSuperview()
        }
    }

}