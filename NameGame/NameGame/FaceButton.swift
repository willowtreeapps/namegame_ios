//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class FaceButton: UIButton {

    var id: Int = 0
    var tintView: UIView = UIView(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        setTitleColor(.white, for: .normal)
        titleLabel?.alpha = 0.0

        tintView.alpha = 0.0
        tintView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tintView)

        tintView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tintView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tintView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tintView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    /// A negative match.
    func transitionToFalse() {
        tintView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        UIView.animate(withDuration: 0.5, animations: {
            self.tintView.alpha = 1.0
            self.titleLabel?.alpha = 1.0
        }) { (fini) in
        }
    }
    
    /// A positive match.
    func transitionToTrue() {
        tintView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        UIView.animate(withDuration: 0.5, animations: {
            self.tintView.alpha = 1.0
            self.titleLabel?.alpha = 1.0
        }) { (fini) in
        }
        
    }
    
    /// No tint
    func transitionToNone() {
        tintView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.tintView.alpha = 0.0
        self.titleLabel?.alpha = 0.0
    }

    
    /// Reveal the name
    func revealName() {
        self.titleLabel?.alpha = 1.0
    }
    
    /// Show the user's face on the button.
    func showFace(image: UIImage, profileAt index: Int) {
        //self.imageView?.contentMode = .scaleAspectFit
    
        setBackgroundImage(image, for: .normal)
    
        (self.subviews[0] as! UIImageView).contentMode = .scaleAspectFit
    
        id = index
    }
    
    
}
