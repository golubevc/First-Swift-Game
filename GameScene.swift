//
//  GameScene.swift
//  Game 3
//
//  Created by Alexey Golubev on 15/09/2019.
//  Copyright © 2019 Alexey Golubev. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Счет: \(score)"
        }
    }
    var gameTimer:Timer!
    var aliens = ["alien-1","alien2-1","alien3-1"]
    
    
    let alienCategory:UInt32 = 0x1 << 1
    let bulletCategory:UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()
    var xAccelerate:CGFloat = 0
    
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "Siblion")
        player.position = CGPoint(x: 0, y: -400)
        player.setScale(0.5)
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Счет: 0")
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: -200, y: 500)
        score = 0
        
        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
    
        motionManager.accelerometerUpdateInterval  = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data {
                let acceleration = accelerometrData.acceleration
                self.xAccelerate = CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            }
        }
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAccelerate * 50
        
        if  player.position.x < -350 {
            player.position =  CGPoint(x: 350, y: player.position.y)
        } else if player.position.x > 350 {
            player.position =  CGPoint(x: -350, y: player.position.y)
    }
    }
        
        
    func didBegin(_ contact: SKPhysicsContact) {
        var alienBody:SKPhysicsBody
        var bulletBody:SKPhysicsBody
    
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bulletBody = contact.bodyA
            alienBody = contact.bodyB
            
        } else {
            bulletBody = contact.bodyB
            alienBody = contact.bodyA
        }
        
        if (alienBody.categoryBitMask & alienCategory) != 0 && (bulletBody.categoryBitMask & bulletCategory) != 0 {
            collisionElements(bulletNode: bulletBody.node as! SKSpriteNode, alienNode: alienBody.node as! SKSpriteNode)
        }
    }
    
    func collisionElements(bulletNode:SKSpriteNode, alienNode:SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Vzriv")
        explosion?.position = alienNode.position
        self.addChild(explosion!)
        
    
        self.run(SKAction.playSoundFileNamed("vzriv.mp3", waitForCompletion: false))
        
        bulletNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 5)) {
            explosion?.removeFromParent()
        }
        score += 5
        
    }
    
    @objc func addAlien() {
        aliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: aliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: aliens[0])
        let randomPos = GKRandomDistribution(lowestValue: 20, highestValue: 350)
        let pos = CGFloat(randomPos.nextInt())
        alien.position = CGPoint(x: pos, y: 800)
        alien.setScale(0.3)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = bulletCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animDuration:TimeInterval = 6
    
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: pos, y: -alien.size.height), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actions))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }

    func fireBullet() {
        self.run(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
        
        let bullet = SKSpriteNode(imageNamed: "torpedo-1")
        
        bullet.position = player.position
        bullet.position.y += 5
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.isDynamic = true
        
        
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = alienCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        
        
        self.addChild(bullet)
        
        let animDuration:TimeInterval = 0.3
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: 800), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        
        bullet.run(SKAction.sequence(actions))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

