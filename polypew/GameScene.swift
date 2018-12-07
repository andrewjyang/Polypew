//
//  GameScene.swift
//  polypew
//
//  Created by Andrew Yang on 11/27/18.
//  Copyright © 2018 Andrew Yang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var spawnAstrogon: Timer!
    var astrogons = ["hexagon"]
    
    let astrogonCategory: UInt32 = 0x1 << 1
    let torpedoCategory: UInt32 = 0x1 << 0
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x:0, y: 1472) // change from hard-coded value
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        self.addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "spaceship")
        player.size = CGSize(width: 160, height: 140)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.minY + player.size.height)
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx:0, dy:0) // no effect of gravity in x or y direction
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - player.size.height)
        scoreLabel.fontName = "Menlo-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)
        
        spawnAstrogon = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAstrogon), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func addAstrogon() {
        astrogons = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: astrogons) as! [String]
        let astrogon  = SKSpriteNode(imageNamed: astrogons[0])
        astrogon.size = CGSize(width: 100, height: 100)
        let astrogonPosition = GKRandomDistribution(lowestValue: -300, highestValue: 300)
        let position = CGFloat(astrogonPosition.nextInt())
        astrogon.position = CGPoint(x: position, y: self.frame.size.height + astrogon.size.height)
        
        astrogon.physicsBody?.isDynamic = true
        astrogon.physicsBody?.categoryBitMask = astrogonCategory
        astrogon.physicsBody?.contactTestBitMask = torpedoCategory
        astrogon.physicsBody?.collisionBitMask = 0
        self.addChild(astrogon)
        let animationDuration: TimeInterval = 5
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: position, y: -astrogon.size.height), duration: animationDuration))
        actions.append(SKAction.removeFromParent())

        astrogon.run(SKAction.sequence(actions))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
