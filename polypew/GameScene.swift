
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
 * play button: <div>Icons made by <a href="https://www.flaticon.com/authors/smashicons" title="Smashicons">Smashicons</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 * info: <div>Icons made by <a href="https://www.flaticon.com/authors/smashicons" title="Smashicons">Smashicons</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 * Color Hex Values:
 - orange: #E5AE14
 - yellow: #FED436
 - red: #CB001E
 - green: #81D849
 - purple: #7F21B8
 - blue: #0953EB
 * Created by Andrew Yang and Andrew Zenoni on November 29, 2018
 * Copyright © 2018 Andrew Yang and Andrew Zenoni. All rights reserved.
 */

import SpriteKit
import GameplayKit
import CoreMotion
import UIKit


// Class representing the game scene
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    let motionManager: CMMotionManager = CMMotionManager()
    
    var leftWall = SKSpriteNode()
    var rightWall = SKSpriteNode()
    
    var viewController: GameViewController? = nil
    
    var multiplier: Int = 1 {
        didSet {
            multiplierLabel.text = "Multiplier: x\(multiplier)"
        }
    }
    
    var collisionCounter: Int = 0 {
        didSet {
            // if the user has destroyed 20 astrogons, present a question
            if collisionCounter % 20 == 0 {
                pauseGame()
                
                // Generate a question
                let questionAnswer = QuestionAnswer()
                
                // generate an alert asking the question
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
                
                // if the user selects the first option
                alert.addAction(UIAlertAction(title: questionAnswer.options[1], style: .default, handler: { action in
                    // if the first option is the answer
                    if(questionAnswer.options[1] == questionAnswer.answer) {
                        self.multiplier += 1
                    } else {
                        self.multiplier = 1
                    }
                    self.isPaused = false
                    self.dropAstrogens()
                }))
                
                // if the user selects the second option
                alert.addAction(UIAlertAction(title: questionAnswer.options[2], style: .default, handler: { action in
                    // if the second option is the answer
                    if(questionAnswer.options[2] == questionAnswer.answer) {
                        self.multiplier += 1
                        print("guessed correctly")
                    } else {
                        self.multiplier = 1
                    }
                    self.isPaused = false
                    self.dropAstrogens()
                }))
                
                // if the user selects the third option
                alert.addAction(UIAlertAction(title: questionAnswer.options[3], style: .default, handler: { action in
                    // if the third option is the answer
                    if(questionAnswer.options[3] == questionAnswer.answer) {
                        self.multiplier += 1
                        
                        print("guessed correctly")
                    } else {
                        self.multiplier = 1
                    }
                    self.isPaused = false
                    self.dropAstrogens()
                }))
                
                // present the alert to the view
                if self.viewController != nil {
                    self.viewController!.present(alert, animated: true, completion: nil)
                }
                
                
            }
        }
    }
    
    var highScores = [HighScore]() {
        didSet {
            HighScore.saveToFile(scores: highScores)
        }
    }
    var highScoreLabel: SKLabelNode!
    
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
                highScores.append(HighScore(score: score))
                highScoreLabel.text = "High Score: \(getHighScore(highScores: highScores))"
                pauseGame()
                self.playButton.isHidden = false
                self.infoButton.isHidden = false
                self.highScoreLabel.isHidden = false
            }
            healthLabel.text = "Health: \(playerHealth)"
        }
    }
    
    var spawnAstrogon: Timer!
    var astrogons = ["triangle", "square", "pentagon", "hexagon", "octagon"]
    var instructions = """
    Polypew is a simple and fun game to improve your math skills!
    As you are voyaging through space, you soon find yourself
    trapped in a field of endless astrogons (astroid polygons).

    Instructions:
    Tilt your phone to avoid the astrogons.
    Tap the screen to fire your torpedoes.

    You lose health if an astrogon comes into contact with your spaceship.
    The number of sides an astrogon has determines the amount of damage you will receive.
    For every few astrogons destroyed, you will be prompted a math question.
    For every correct math question answered, your score multiplier will increase.

    Have fun and good luck!
    """
    var playButton: SKSpriteNode!
    var infoButton: SKNode!
    
    
    enum NodeCategory: UInt32 {
        case player = 1
        case astrogon = 2
        case laser = 4
        case wall = 8
    }
    
    /**
     Scene came into view. Perform initial setup steps
     
     - Parameter view: the view that is loaded
    */
    override func didMove(to view: SKView) {
        initializeGame()
        pauseGame()
        motionManager.startAccelerometerUpdates()
        print(HighScore.scoresPListURL)
    }
    
    /**
     Initialize all values needed for to start a new game
    */
    func initializeGame() {
        // initialize the starfield
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x:0, y: 1472) // change from hard-coded value
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        self.addChild(starfield)
        
        // initialize the player
        player = SKSpriteNode(imageNamed: "spaceship")
        player.size = CGSize(width: 160, height: 140)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.minY + player.size.height)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        
        // initialize the player's physics body
        player.physicsBody?.categoryBitMask = NodeCategory.player.rawValue
        player.physicsBody?.contactTestBitMask = NodeCategory.astrogon.rawValue
        player.physicsBody?.collisionBitMask = NodeCategory.wall.rawValue
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.mass = 0.01
        addChild(player)
        
        // set the gravity for the the scene
        self.physicsWorld.gravity = CGVector(dx:0, dy:0) // no effect of gravity in x or y direction
        self.physicsWorld.contactDelegate = self
        
        // initialize the score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: self.frame.maxX - 150, y: self.frame.maxY - player.size.height)
        scoreLabel.fontName = "Menlo"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor(red: 0xE5, green: 0xAE, blue: 0x14)
        score = 0
        self.addChild(scoreLabel)
        
        // initialize the multiplier label
        multiplierLabel = SKLabelNode(text: "Multiplier: x1")
        multiplierLabel.position = CGPoint(x: self.frame.minX + 194, y: self.frame.maxY - 1.4 * player.size.height)
        multiplierLabel.fontName = "Menlo"
        multiplierLabel.fontSize = 36
        multiplierLabel.fontColor = UIColor(red: 0xE5, green: 0xAE, blue: 0x14)
        self.addChild(multiplierLabel)
        
        // initialize the health label
        healthLabel = SKLabelNode(text: "Health: 25")
        healthLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.maxY - player.size.height)
        healthLabel.fontName = "Menlo"
        healthLabel.fontSize = 36
        healthLabel.fontColor = UIColor(red: 0xE5, green: 0xAE, blue: 0x14)
        self.addChild(healthLabel)
        
        // initialize the leftwall of the app
        leftWall = SKSpriteNode(color: .white, size: CGSize(width: 10, height: self.frame.height))
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: self.frame.height))
        leftWall.position = CGPoint(x: self.frame.minX, y: 0)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = NodeCategory.wall.rawValue
        leftWall.color = UIColor(red: 0xE5, green: 0xAE, blue: 0x14)
        addChild(leftWall)
        
        // initialize the right wall of the app
        rightWall = SKSpriteNode(color: .white, size: CGSize(width: 10, height: self.frame.height))
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: self.frame.height))
        rightWall.position = CGPoint(x: self.frame.maxX, y: 0)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = NodeCategory.wall.rawValue
        rightWall.color = UIColor(red: 0xE5, green: 0xAE, blue: 0x14)
        addChild(rightWall)
        
        // set default values for labels
        self.multiplier = 1
        self.score = 0
        self.playerHealth = 25
        
        // initialize the play button
        playButton = SKSpriteNode(imageNamed: "play-button")
        playButton.position = CGPoint(x: 0, y: 0)
        self.zPosition = 1
        self.addChild(playButton)
        
        // initialize the info button
        infoButton = SKSpriteNode(imageNamed: "info")
        infoButton.position = CGPoint(x: 0, y: 0 - player.size.height)
        self.zPosition = 1
        self.addChild(infoButton)
        
        if let highScores = HighScore.loadFromFile() {
            self.highScores = highScores
        } else {
            highScores.append(HighScore(score: 0))
        }
        
        for score in highScores {
            print(score.score)
        }
        
        highScoreLabel = SKLabelNode(text: "High Score: \(String(describing: getHighScore(highScores: highScores)))")
        highScoreLabel.position = CGPoint(x: 0, y: 0 - 2 * player.size.height)
        highScoreLabel.fontName = "Menlo"
        highScoreLabel.fontSize = 36
        highScoreLabel.fontColor = UIColor(red: 0xE5, green: 0xAE, blue: 0x14)
        self.zPosition = 1
        self.addChild(highScoreLabel)

        // begin dropping astrogens
        dropAstrogens()
    }
    
    func getHighScore(highScores: [HighScore]) -> Int {
        let highScore = highScores.max{$0.score < $1.score}
        if let highScore = highScore {
            return highScore.score
        } else {
            return 0
        }
    }
    
    /**
     Pause the game
    */
    func pauseGame() {
        self.isPaused = true
        spawnAstrogon.invalidate()
    }
    
    /**
     Drop astrogens
    */
    func dropAstrogens() {
        spawnAstrogon = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAstrogon), userInfo: nil, repeats: true)
    }
    
    /**
     Add an astrogen to the screen
    */
    @objc func addAstrogon() {
        // generate an astrogen object
        astrogons = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: astrogons) as! [String]
        let imageName = astrogons.randomElement()!
        let astrogon  = SKSpriteNode(imageNamed: imageName)
        astrogon.name = imageName
        astrogon.size = CGSize(width: 84, height: 84)
        
        // generate a random x value for the astrogon to drop down
        let astrogonPosition = GKRandomDistribution(lowestValue: Int(self.frame.minX + astrogon.size.width), highestValue: Int(self.frame.maxX - astrogon.size.width))
        let position = CGFloat(astrogonPosition.nextInt())
        astrogon.position = CGPoint(x: position, y: self.frame.size.height + astrogon.size.height)
        
        // add the physics body for the astrogon
        astrogon.physicsBody = SKPhysicsBody(rectangleOf: astrogon.size)
        astrogon.physicsBody?.isDynamic = true
        astrogon.physicsBody?.categoryBitMask = NodeCategory.astrogon.rawValue
        astrogon.physicsBody?.contactTestBitMask = NodeCategory.laser.rawValue | NodeCategory.player.rawValue
        astrogon.physicsBody?.collisionBitMask = 0
        self.addChild(astrogon)
        let animationDuration: TimeInterval = 6
        
        // generate actions for the astrogon
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: position, y: self.frame.minY - astrogon.size.height), duration: animationDuration))
        actions.append(SKAction.removeFromParent())
        astrogon.run(SKAction.sequence(actions))
        
        // rotate the astrogon
        let rotateAstrogon = SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 2)
        let rotateAstrogonForever = SKAction.repeatForever(rotateAstrogon)
        astrogon.run(rotateAstrogonForever)
    
    }
    
    /**
     Fire the laser on the ship
    */
    func fireLaser() {
        // run sounds and build object
        self.run(SKAction.playSoundFileNamed("pew.mp3", waitForCompletion: false))
        let laser = SKSpriteNode(imageNamed: "laser")
        laser.position = player.position
        laser.position.y += 5
        laser.physicsBody = SKPhysicsBody(circleOfRadius: laser.size.width / 2)
        laser.physicsBody?.isDynamic = true
        
        // setup the physics body of the laser
        laser.physicsBody?.categoryBitMask = NodeCategory.laser.rawValue
        laser.physicsBody?.contactTestBitMask = NodeCategory.astrogon.rawValue
        laser.physicsBody?.collisionBitMask = 0
        laser.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(laser)
        
        // animate the laser
        let animationDuration: TimeInterval = 0.3
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actions.append(SKAction.removeFromParent())
        laser.run(SKAction.sequence(actions))
    }
    
    /**
     Function called whenever the user finishes touching the screen
     
     - Parameter touches: The touch that is happening
     - Parameter event: The even occuring
    */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // determine where the touch happened
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            // see if the user touched the info button and game is paused
            if infoButton.contains(location) && self.isPaused {
                let alertController = UIAlertController(title: "Welcome to Polypew!", message: instructions, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
                self.viewController!.present(alertController, animated: true)
            } else if playButton.contains(location) && self.isPaused { // user touches play button and game is paused
                self.removeAllChildren()
                initializeGame()
                self.isPaused = false
                self.playButton.isHidden = true
                self.infoButton.isHidden = true
                self.highScoreLabel.isHidden = true
            }
        }
        
        // if the game is not paused, fire the laser
        if !self.isPaused {
            fireLaser()
        }
    }
    
    /**
     Function called before each frame is rendered
     
     - Parameter currentTime: Current time of the system
    */
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Get MotionManager data
        if let data = motionManager.accelerometerData {
            // Only get use data if it is "tilt enough"
            if (fabs(data.acceleration.x) > 0.2) {
                
                // Apply force to the moving object
                player.physicsBody?.applyForce(CGVector(dx: 12 * CGFloat(data.acceleration.x), dy: 0))
                
            }
        }
    }
    
    
    /**
     Called when two bodies come into contact with one another
     
     - Parameter contact: The contact that is happening
    */
    func didBegin(_ contact: SKPhysicsContact) {
        // if an astrogon is initiating contact
        if contact.bodyA.categoryBitMask == NodeCategory.astrogon.rawValue || contact.bodyB.categoryBitMask == NodeCategory.astrogon.rawValue {
            // if a laser is hitting an astrogon
            if contact.bodyA.categoryBitMask == NodeCategory.laser.rawValue || contact.bodyB.categoryBitMask == NodeCategory.laser.rawValue {
                // we are hitting a laser
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                animateExplosion(at: (contact.bodyA.node?.position)!, name: (contact.bodyA.node?.name)!)
                score += 1*multiplier
                collisionCounter += 1
            } // if the astrogon is hitting the player
            else if contact.bodyA.categoryBitMask == NodeCategory.player.rawValue || contact.bodyB.categoryBitMask == NodeCategory.player.rawValue {
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
        }
    }
    
    /**
     Animate an explosion at passed in point
     
     - Parameter position: The position to animate the explosion
     - Parameter name: Name of the astrogen being exploded
    */
    func animateExplosion(at position: CGPoint, name: String) {
        // run sounds for an explosion
        self.run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
        let explosion = SKEmitterNode(fileNamed: "obliteration")!
        
        // setup animation for explosion
        explosion.particleColorSequence = nil
        explosion.particleColorBlendFactor = 1.0
        explosion.particleColor = getColorFromName(name: name)
        explosion.particleRotation = 2 * CGFloat.pi
        explosion.particleRotationRange = 4 * CGFloat.pi
        explosion.particleRotationSpeed = 2 * CGFloat.pi
        explosion.position = position // change from hard-coded value
        explosion.advanceSimulationTime(1)
        explosion.zPosition = 1
        
        // fade out the animation
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let remove = SKAction.removeFromParent()
        explosion.run(SKAction.sequence([fadeOut, remove]))
        self.addChild(explosion)
    }
    
    /**
     Gets the number of sides based on the passed in name
     
     - Parameter name: Name of the astrogen
     - Returns: The number of sides the astrogen has
    */
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
    
    /**
     Gets the color based on the name of the astrogen
     
     - Parameter name: Name of the astrogen
     - Returns: Color representing the astrogen
    */
    func getColorFromName(name: String) -> SKColor {
        switch name {
        case "triangle":
            return SKColor.init(red: 0xFE, green: 0xD4, blue: 0x36)
        case "square":
            return SKColor.init(red: 0xCB, green: 0x00, blue: 0x1E)
        case "pentagon":
            return SKColor.init(red: 0x81, green: 0xD8, blue: 0x49)
        case "hexagon":
            return SKColor.init(red: 0x09, green: 0x53, blue: 0xEB)
        case "octagon":
            return SKColor.init(red: 0x7F, green: 0x21, blue: 0xB8)
        default:
            return SKColor.white
        }
    }
}

// modify the UIColor so we use color values that are actually our shape
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
