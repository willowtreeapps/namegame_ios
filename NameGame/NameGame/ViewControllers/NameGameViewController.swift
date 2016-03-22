//
//  ViewController.swift
//  NameGame
//
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .Portrait : .LandscapeLeft
        configureSubviews(orientation)
    }

    // Load JSON data from API
    func loadData() {

    }

    @IBAction func faceTapped(button: FaceButton) {

    }

    func configureSubviews(orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .Vertical
            innerStackView1.axis = .Horizontal
            innerStackView2.axis = .Horizontal
        } else {
            outerStackView.axis = .Horizontal
            innerStackView1.axis = .Vertical
            innerStackView2.axis = .Vertical
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
