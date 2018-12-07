
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
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var spawnAstrogon: Timer!
    var astrogons = ["triangle", "square", "pentagon", "hexagon", "octagon"]
    
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
        let animationDuration: TimeInterval = 6
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: position, y: -astrogon.size.height), duration: animationDuration))
        actions.append(SKAction.removeFromParent())

        astrogon.run(SKAction.sequence(actions))
        
        let rotateAstrogon = SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 2)
        let rotateAstrogonForever = SKAction.repeatForever(rotateAstrogon)
        astrogon.run(rotateAstrogonForever)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
