//
//  GameScene.swift
//  Missile Escape
//
//  Created by Alan Carvajal
//  Copyright (c) 2015 Alan Carvajal. All rights reserved.
//

import SpriteKit



class GameScene: SKScene , SKPhysicsContactDelegate {
    
    
    var spaceShip = SKSpriteNode ()
    var bgSpace = SKSpriteNode ()
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var labelHolder = SKSpriteNode()
    
    
    let shipGroup:UInt32 = 1 << 1
    let objectGroup:UInt32 = 1 << 2
    let wallGroup:UInt32 = 1 << 3
    let missileGroup:UInt32 = 1 << 4
    
    var gameOver = 0
    
    var movingObjects = SKNode()

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.addChild(movingObjects)
        
        makeBackground()
        
        self.addChild(labelHolder)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 150)
        scoreLabel.zPosition = 1000
        self.addChild(scoreLabel)
        
        //add spaceship
        
        var spaceShipTexture = SKTexture (imageNamed: "productImgs/F5S4.png")
        spaceShip = SKSpriteNode (texture: spaceShipTexture)
        spaceShip.position = CGPoint(x:CGRectGetMidX(self.frame) / 3, y:CGRectGetMidY(self.frame))
        spaceShip.xScale = 0.7
        spaceShip.yScale = 0.7
        
        spaceShip.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(spaceShip.frame.size.width, spaceShip.frame.size.height))
        
        spaceShip.physicsBody?.dynamic = true
        spaceShip.physicsBody?.allowsRotation = false
        spaceShip.physicsBody?.categoryBitMask = shipGroup
        spaceShip.physicsBody?.collisionBitMask = 2
        
        spaceShip.zPosition = 10
        
        self.addChild(spaceShip)
        
      
        
        //add ground
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake (self.frame.size.width * 2, 250)) //180
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = objectGroup
        ground.physicsBody?.contactTestBitMask = shipGroup
        
        self.addChild(ground)
        
        //add top
        
        let top = SKNode()
        top.position = CGPointMake(0, 1180)
        top.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake (self.frame.size.width * 2, 1200)) // 1000
        top.physicsBody?.dynamic = false
        top.physicsBody?.categoryBitMask = objectGroup
        top.physicsBody?.contactTestBitMask = shipGroup
        
        self.addChild(top)
        
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makeMissile"), userInfo: nil, repeats: true)
        
        
        var wall = SKNode()
        wall.position = CGPoint(x:10 , y: CGRectGetMidY(self.frame))
        wall.physicsBody = SKPhysicsBody (rectangleOfSize: CGSizeMake(3, self.frame.size.height))
        
        wall.physicsBody?.dynamic = false
        wall.physicsBody?.categoryBitMask = wallGroup
        wall.physicsBody?.contactTestBitMask = missileGroup
        wall.physicsBody?.collisionBitMask = missileGroup
        self.addChild(wall)

        
        
    }
    
    func makeBackground(){
        //add bg
        
        if gameOver == 0 {
        
        var bgTexture = SKTexture(imageNamed: "productImgs/1820925.jpg")
        
        var backgroundAnimated = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 12)
        var replaceBackground = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var backgroundMoveForever = SKAction.repeatActionForever(SKAction.sequence([backgroundAnimated,replaceBackground]))
        
        for var i:CGFloat=0; i<3; i++ {
            
            bgSpace = SKSpriteNode(texture: bgTexture)
            bgSpace.position = CGPoint (x: CGRectGetMidX(self.frame)/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bgSpace.size.height = self.frame.height
            bgSpace.runAction(backgroundMoveForever)
            movingObjects.addChild(bgSpace)
            
            //check this part needed
            
        }
        
        }

        
    }
    
    func makeMissile(){
        
        if gameOver == 0 {
        
       
                 var missile = SKSpriteNode(imageNamed: "productImgs/missile-hi.png")
            missile.setScale(0.38)
            
            // Adding SpriteKit physics body for collision detection
            missile.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(missile.frame.size.width,missile.frame.size.height))
            missile.physicsBody?.dynamic = false
            
            
            
            missile.physicsBody?.categoryBitMask = missileGroup
            missile.physicsBody?.collisionBitMask = shipGroup | wallGroup
            missile.physicsBody?.contactTestBitMask = shipGroup | wallGroup
           
            
            
            missile.physicsBody?.usesPreciseCollisionDetection = true
            missile.name = "missile"


            // Selecting random y position for missile
            var random = arc4random_uniform(UInt32(self.frame.size.height)) + 1
        
        var randomPosition = CGFloat(random)
            missile.position = CGPointMake(self.frame.size.width + 20, randomPosition)
    
            
            var movementAmount = arc4random_uniform(UInt32(self.frame.size.height / 2))
            
            var moveMissile = SKAction.moveByX(-self.frame.size.width * 5, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
            var removeMissile = SKAction.removeFromParent()
            var moveAndRemoveMissile = SKAction.sequence([moveMissile, removeMissile])

            missile.runAction(moveAndRemoveMissile)
        
            movingObjects.addChild(missile)
            
            //add wall
            
           

        } else if gameOver == 0 {
            gameOver = 1
            movingObjects.speed = 0
            gameOverLabel.fontName = "Helvetica"
            gameOverLabel.fontSize = 40
            gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame) , CGRectGetMidY(self.frame))
            gameOverLabel.zPosition = 100000
            labelHolder.addChild(gameOverLabel)
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask > missileGroup || contact.bodyB.categoryBitMask > missileGroup {
            score++
            scoreLabel.text = "\(score)"
        }
        else if gameOver == 0 {
                
                gameOver = 1
                
                movingObjects.speed = 0
                
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over! Tap to play again."
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelHolder.addChild(gameOverLabel)
                
            }

        
    }
        
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        if (gameOver == 0) {
            spaceShip.physicsBody?.velocity = CGVectorMake(0, 0)
            spaceShip.physicsBody?.applyImpulse(CGVectorMake(0, 300))
        } else {
            score = 0
            scoreLabel.text = "0"
            movingObjects.removeAllChildren()
            
            makeBackground()
            
            spaceShip.position = CGPoint(x:CGRectGetMidX(self.frame) / 3, y:CGRectGetMidY(self.frame))
            spaceShip.physicsBody?.velocity = CGVectorMake(0, 0)
            labelHolder.removeAllChildren()
            gameOver = 0
            movingObjects.speed = 1
            
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
