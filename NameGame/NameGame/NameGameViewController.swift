//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var activity: UIActivityIndicatorView!
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
                DispatchQueue.main.async {
                    self.playGame()
                }
            }
        }
    }
    
    /// Commence play.
    func playGame() {
        title = nameGame.gameTitle()
        resetButtons()
        nameGame.newGame()
        playButton.isEnabled = false
        playRound()
    }
    
    /// Play a new round of same game.
    func playRound() {
        resetButtons()
        activity.startAnimating()
        nameGame.playRound()
        
        questionLabel.text = "Who is " + nameGame.getSolutionProfileName() + "?"
        
        var countImagesRetrieved = 0
        let count = nameGame.inPlayGameItems.count
        
        for (index, profileIndex) in nameGame.inPlayGameItems.enumerated() {
            
            nameGame.getImage(at: profileIndex) { (image) in

                DispatchQueue.main.async {
                    self.imageButtons[index].showFace(image: image, profileAt: profileIndex)
                }

                countImagesRetrieved += 1
                if countImagesRetrieved < count {
                    // waiting
                } else {
                    DispatchQueue.main.async {
                        self.revealButtons()
                        self.activity.stopAnimating()
                        self.playButton.isEnabled = true
                    }
                }
            }
        }
    }

    /// UnHide all of the buttons.
    private func revealButtons() {
        for button in imageButtons {
            button.isHidden = false
        }
    }
    
    /// Hides all of the buttons and resets sate to normal.
    private func resetButtons() {
        for button in imageButtons {
            button.isHidden = true
            button.transitionToNone()
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
            button.transitionToTrue()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.revealAllNames()
            }
        } else {
            button.transitionToFalse()
        }
    }
    
    /// Reveal the result of the choice for button.
    func revealAllNames() {
        for button in imageButtons {
            button.setTitle(nameGame.getProfileName(at: button.id), for: .normal)
            button.revealName()
        }
    }


    @IBAction func actionButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Game Play Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "All", style: .default) { action in
            self.nameGame.gameFilter = .all
            self.playGame()
        })
        
        alert.addAction(UIAlertAction(title: "Current Employees", style: .default) { action in
            self.nameGame.gameFilter = .current
            self.playGame()
        })
        alert.addAction(UIAlertAction(title: "Former Employees", style: .default) { action in
            self.nameGame.gameFilter = .former
            self.playGame()
        })
        
        alert.addAction(UIAlertAction(title: "Matthew Employees", style: .default) { action in
            self.nameGame.gameFilter = .custom("Mat")
            self.playGame()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
        })

        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func playButtonTapped(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        self.playRound()
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
