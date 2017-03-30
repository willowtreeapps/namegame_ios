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

    /// NameGame object loads and processes the data.
    private var nameGame = NameGame()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        
        nameGame.delegate = self
        
        prepareGamePlay()
  
    }

    // MARK: GamePlay
    
    
    func prepareGamePlay() {
        DispatchQueue.global().async {
            self.nameGame.loadGameData {
                self.playGame()
            }
        }
    }
    
    /// Commence play.
    func playGame() {
        
        hideButtons()
        
        nameGame.newGame()
        
        playRound()

    }
    
    /// Play a new round of same game.
    func playRound() {

        hideButtons()

        nameGame.playRound()
        
        questionLabel.text = "Who is " + nameGame.getSolutionProfileName() + "?"
        
        
        var countImagesRetrieved = 0
        let count = nameGame.numberPeople
        
        for (index, profileIndex) in nameGame.inPlayGameItems.enumerated() {
            nameGame.getImage(at: profileIndex) { (image) in
                
                self.imageButtons[index].showFace(image: image, profileAt: profileIndex)

                countImagesRetrieved += 1
                //print("\(countImagesRetrieved) \(count)")
                if countImagesRetrieved < count {
                    // waiting
                } else {
                    self.revealButtons()
                }
            }
        }
    }
    
    
    private func hideButtons() {
        for button in imageButtons {
            button.isHidden = true
        }
    }
    
    private func revealButtons() {
        for button in imageButtons {
            button.isHidden = false
        }
    }
    
    // MARK: Actions

    @IBAction func faceTapped(_ button: FaceButton) {
        
        button.setTitle(nameGame.getProfileName(at: button.id), for: .normal)

        revealChoiceResult(button)
    }

    /// Reveal the result of the choice for button.
    func revealChoiceResult(_ button: FaceButton) {
        
        if nameGame.choiceResult(choiceIndex: button.id) {
            print("YES")
            button.transitionToTrue()
        } else {
            print("NO")
            button.transitionToFalse()
        }
    }

    
    // MARK: Layout
    
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

extension NameGameViewController: NameGameDelegate {
}
