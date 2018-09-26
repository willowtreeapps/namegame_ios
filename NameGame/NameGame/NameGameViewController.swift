//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    
    var game: NameGame = NameGame()
    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        
        // Indicate the game is loading...
        
        weak var blockSelf: NameGameViewController? = self
        game.loadGameData {
            // TODO show button to start game/ hidden before load?
            blockSelf?.initializeGameView()
        }
    }
    
    // MARK: - Game View methods
    private func initializeGameView() {
        game.chooseProfiles()
        game.loadProfileImages()
        // SVprogress.start
    }
    
    // Helper method for Game Question
    func poseQuestion() {
        if let winner: Coworkers = game.sixProfiles[game.winningProfileId!] {
            let question: String = NSLocalizedString("Who is ", comment: "Question being posed to player")
            let firstName: String = winner.firstName ?? ""
            let lastName: String = winner.lastName ?? ""
            
            var space: String = ""
            if !firstName.isEmpty {
                space = " "
            }
            self.questionLabel.text = question + firstName + space + lastName + "?"
        }
    }
    
    func showResult() {
        // To-do
    }
    
    // MARK: - Player interaction methods
    private func resetGame() {
        self.initializeGameView()
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        // TO-DO
    }
    // MARK: -

    func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }

        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
}

// MARK: - NameGameDelegate Implementation
extension NameGameViewController: NameGameDelegate {
    func complete() {
        // SVprogresshud.dismiss()
        var buttonIndex: Int = 0
        for (id, _) in game.sixProfiles {
            self.imageButtons[buttonIndex].setImage(ProfileImageService.instance().getImage(profileId: id), for: .normal)
            buttonIndex += 1
        }
        
        poseQuestion()
    }
}
