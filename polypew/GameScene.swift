
/* GameScene.swift
 * polypew
 *
 * Description: Polypew is a an educational space-themed game using the SpriteKit framework.
 *
 * CPSC 315-01, Fall 2018
 * Programming Assignment: Final Project
 * Sources:
 *  triangle icon: <div>Icons made by <a href="https://www.flaticon.com/authors/smashicons" title="Smashicons">Smashicons</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 *  square icon: <div>Icons made by <a href="https://www.flaticon.com/authors/smashicons" title="Smashicons">Smashicons</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 *  pentagon icon: <div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 *  hexagon icon: <div>Icons made by <a href="https://www.flaticon.com/authors/pixel-perfect" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 *  octagon icon: <div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 * Created by Andrew Yang and Andrew Zenoni on November 29, 2018
 * Copyright © 2018 Andrew Yang and Andrew Zenoni. All rights reserved.
 */

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var viewController: GameViewController? = nil
    
    var multiplier: Int = 1 {
        didSet {
            multiplierLabel.text = "x\(multiplier)"
        }
    }
    
    var collisionCounter: Int = 0 {
        didSet {
            if collisionCounter % 5 == 0 {
                pauseGame()
                let questionAnswer = QuestionAnswer()
                print("Qustion: \(questionAnswer.question)")
                print("Options: \(questionAnswer.options)")
                print("Answer: \(questionAnswer.answer)")
                
                let alert = UIAlertController(title: questionAnswer.question, message: "Pick an answer from below:", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: questionAnswer.options[0], style: .default, handler: { action in
                    if(questionAnswer.options[0] == questionAnswer.answer) {
                        self.multiplier += 1
                        print("guessed correctly")
                    } else {
                        self.multiplier = 1
                    }
                    self.isPaused = false
                    self.dropAstrogens()
                }))
                
                alert.addAction(UIAlertAction(title: questionAnswer.options[1], style: .default, handler: { action in
                    if(questionAnswer.options[1] == questionAnswer.answer) {
                        self.multiplier += 1
                        print("guessed correctly")
                    } else {
                        self.multiplier = 1
                    }
                    self.isPaused = false
                    self.dropAstrogens()
                }))
                
                alert.addAction(UIAlertAction(title: questionAnswer.options[2], style: .default, handler: { action in
                    if(questionAnswer.options[2] == questionAnswer.answer) {
                        self.multiplier += 1
                        print("guessed correctly")
                    } else {
                        self.multiplier = 1
                    }
                    self.isPaused = false
                    self.dropAstrogens()
                }))
                
                alert.addAction(UIAlertAction(title: questionAnswer.options[3], style: .default, handler: { action in
                    if(questionAnswer.options[3] == questionAnswer.answer) {
                        self.multiplier += 1
                        
                        print("guessed correctly")
                    } else {
                        self.multiplier = 1
                    }
                    self.isPaused = false
                    self.dropAstrogens()
                }))
                
                if self.viewController != nil {
                    self.viewController!.present(alert, animated: true, completion: nil)
                }
                
                
            }
        }
    }
    
    var scoreLabel: SKLabelNode!
    var healthLabel: SKLabelNode!
    var multiplierLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var playerHealth: Int = 25 {
        didSet {
            if playerHealth <= 0 {
                playerHealth = 0
                pauseGame()
            }
            healthLabel.text = "Health: \(playerHealth)"
        }
    }
    
    var spawnAstrogon: Timer!
    var astrogons = ["triangle", "square", "pentagon", "hexagon", "octagon"]
    
    
    enum NodeCategory: UInt32 {
        case player = 1
        case astrogon = 2
        case laser = 4
    }
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x:0, y: 1472) // change from hard-coded value
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        self.addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "spaceship")
        player.size = CGSize(width: 160, height: 140)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.minY + player.size.height)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        
        player.physicsBody?.categoryBitMask = NodeCategory.player.rawValue
        player.physicsBody?.contactTestBitMask = NodeCategory.astrogon.rawValue
        player.physicsBody?.collisionBitMask = 0
        addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx:0, dy:0) // no effect of gravity in x or y direction
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - player.size.height)
        scoreLabel.fontName = "Marker Felt Thin"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)
        
        multiplierLabel = SKLabelNode(text: "x1")
        multiplierLabel.position = CGPoint(x: self.frame.maxX - 150, y: self.frame.maxY - player.size.height)
        multiplierLabel.fontName = "Marker Felt Thin"
        multiplierLabel.fontSize = 36
        multiplierLabel.fontColor = UIColor.green
        self.addChild(multiplierLabel)
        
        healthLabel = SKLabelNode(text: "Health: 25")
        healthLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.maxY - player.size.height)
        healthLabel.fontName = "Marker Felt Thin"
        healthLabel.fontSize = 36
        healthLabel.fontColor = UIColor.white
        self.addChild(healthLabel)
    
        dropAstrogens()
        
    }
    
    func pauseGame() {
        self.isPaused = true
        spawnAstrogon.invalidate()
    }
    
    func dropAstrogens() {
        spawnAstrogon = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAstrogon), userInfo: nil, repeats: true)
    }
    
    @objc func addAstrogon() {
        astrogons = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: astrogons) as! [String]
        let imageName = astrogons.randomElement()!
        let astrogon  = SKSpriteNode(imageNamed: imageName)
        astrogon.name = imageName
        astrogon.size = CGSize(width: 84, height: 84)
//        let astrogonPosition = GKRandomDistribution(lowestValue: Int(self.frame.minX + astrogon.size.width), highestValue: Int(self.frame.maxX - astrogon.size.width))
        
//        let position = CGFloat(astrogonPosition.nextInt())
        let position = CGFloat(frame.midX)
        astrogon.position = CGPoint(x: position, y: self.frame.size.height + astrogon.size.height)
        astrogon.physicsBody = SKPhysicsBody(rectangleOf: astrogon.size)
        astrogon.physicsBody?.isDynamic = true
        astrogon.physicsBody?.categoryBitMask = NodeCategory.astrogon.rawValue
        astrogon.physicsBody?.contactTestBitMask = NodeCategory.laser.rawValue | NodeCategory.player.rawValue
        astrogon.physicsBody?.collisionBitMask = 0
        self.addChild(astrogon)
        let animationDuration: TimeInterval = 6
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: position, y: self.frame.minY - astrogon.size.height), duration: animationDuration))
        actions.append(SKAction.removeFromParent())

        astrogon.run(SKAction.sequence(actions))
        
        
        let rotateAstrogon = SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 2)
        let rotateAstrogonForever = SKAction.repeatForever(rotateAstrogon)
        astrogon.run(rotateAstrogonForever)
    
    }
    
    func fireLaser() {
        self.run(SKAction.playSoundFileNamed("pew.mp3", waitForCompletion: false))
        let laser = SKSpriteNode(imageNamed: "laser")
        laser.position = player.position
        laser.position.y += 5
        laser.physicsBody = SKPhysicsBody(circleOfRadius: laser.size.width / 2)
        laser.physicsBody?.isDynamic = true
        
        laser.physicsBody?.categoryBitMask = NodeCategory.laser.rawValue
        laser.physicsBody?.contactTestBitMask = NodeCategory.astrogon.rawValue
        laser.physicsBody?.collisionBitMask = 0
        laser.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(laser)
        
        let animationDuration: TimeInterval = 0.3
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actions.append(SKAction.removeFromParent())
        laser.run(SKAction.sequence(actions))
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isPaused {
            fireLaser()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == NodeCategory.astrogon.rawValue || contact.bodyB.categoryBitMask == NodeCategory.astrogon.rawValue {
            if contact.bodyA.categoryBitMask == NodeCategory.laser.rawValue || contact.bodyB.categoryBitMask == NodeCategory.laser.rawValue {
                // we are hitting a laser
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                animateExplosion(at: (contact.bodyA.node?.position)!, name: (contact.bodyA.node?.name)!)
                score += 1*multiplier
                collisionCounter += 1
            } else if contact.bodyA.categoryBitMask == NodeCategory.player.rawValue || contact.bodyB.categoryBitMask == NodeCategory.player.rawValue {
                var shapeSides = 0
                if contact.bodyA.categoryBitMask == NodeCategory.astrogon.rawValue {
                    contact.bodyA.node?.removeFromParent()
                    shapeSides = getSidesFromName(name:(contact.bodyA.node?.name)!)
                } else {
                    contact.bodyB.node?.removeFromParent()
                    shapeSides = getSidesFromName(name:(contact.bodyB.node?.name)!)
                }
                playerHealth -= shapeSides
            }
//            print("We have contact with an astrogen")
        }
    }
    
    func animateExplosion(at position: CGPoint, name: String) {
        self.run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
        let explosion = SKEmitterNode(fileNamed: "obliteration")!
        explosion.particleColorSequence = nil
        explosion.particleColorBlendFactor = 1.0
        explosion.particleColor = getColorFromName(name: name)
        explosion.particleRotation = 2 * CGFloat.pi
        explosion.particleRotationRange = 4 * CGFloat.pi
        explosion.particleRotationSpeed = 2 * CGFloat.pi
        explosion.position = position // change from hard-coded value
        explosion.advanceSimulationTime(1)
        explosion.zPosition = 1
        
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let remove = SKAction.removeFromParent()
        explosion.run(SKAction.sequence([fadeOut, remove]))
        self.addChild(explosion)
    }
    
    func getSidesFromName(name: String) -> Int {
        switch name {
            case "triangle":
                return 3
            case "square":
                return 4
            case "pentagon":
                return 5
            case "hexagon":
                return 6
            case "octagon":
                return 8
            default:
                return 0
        }
    }
    
    func getColorFromName(name: String) -> SKColor {
        switch name {
        case "triangle":
            return SKColor.yellow
        case "square":
            return SKColor.red
        case "pentagon":
            return SKColor.green
        case "hexagon":
            return SKColor.blue
        case "octagon":
            return SKColor.purple
        default:
            return SKColor.white
        }
    }
}
