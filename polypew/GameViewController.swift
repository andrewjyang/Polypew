//
//  GameViewController.swift
//  polypew
//
//  Created by Andrew Yang on 11/27/18.
//  Copyright © 2018 Andrew Yang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.viewController = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /**
     Function that is called when coming back to this view
     
     - Parameter segue: The segue causing the table view to come back
     */
    @IBAction func unwindToGame(segue: UIStoryboardSegue) {
        print("Unwinding to table view")
        if let identifier = segue.identifier {
            if identifier == "popBackSegue" {
                if let questionResults = segue.source as? QuestionViewController {
                    if questionResults.correctGuess {
                        
                    }
                }
            }
        }
    }
}
