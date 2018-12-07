
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
    
    
    enum NodeCategory: UInt32 {
        case player = 1
        case astrogon = 2
        case torpedo = 4
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
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        player.zPosition = 1
//        player.physicsBody?.contactTestBitMask =
        addChild(player)
        
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
        let astrogon  = SKSpriteNode(imageNamed: astrogons.randomElement()!)
        astrogon.size = CGSize(width: 84, height: 84)
        let astrogonPosition = GKRandomDistribution(lowestValue: Int(self.frame.minX + astrogon.size.width), highestValue: Int(self.frame.maxX - astrogon.size.width))
        
        let position = CGFloat(astrogonPosition.nextInt())
        astrogon.position = CGPoint(x: position, y: self.frame.size.height + astrogon.size.height)
        
        astrogon.physicsBody?.isDynamic = true
        astrogon.physicsBody?.categoryBitMask = NodeCategory.astrogon.rawValue
        astrogon.physicsBody?.contactTestBitMask = NodeCategory.torpedo.rawValue | NodeCategory.player.rawValue
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
    
    func fireTorpedo() {
        self.run(SKAction.playSoundFileNamed("pew.mp3", waitForCompletion: false))
        let torpedo = SKSpriteNode(imageNamed: "torpedo")
        torpedo.position = player.position
        torpedo.position.y += 5
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width / 2)
        torpedo.physicsBody?.isDynamic = true
        
        torpedo.physicsBody?.categoryBitMask = NodeCategory.torpedo.rawValue
        torpedo.physicsBody?.contactTestBitMask = NodeCategory.astrogon.rawValue
        torpedo.physicsBody?.collisionBitMask = 0
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(torpedo)
        
        let animationDuration: TimeInterval = 0.3
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actions.append(SKAction.removeFromParent())
        torpedo.run(SKAction.sequence(actions))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let torpedo = SKSpriteNode(imageNamed: "torpedo")
        torpedo.size = CGSize(width: 32, height: 32)
        let position = self.player.position
        let move = SKAction.move(to: CGPoint(x: position.x, y: self.frame.maxY + torpedo.size.height), duration: 5)
        
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.height/2)
        torpedo.physicsBody?.affectedByGravity = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // determining when object hit each other
    }
}
