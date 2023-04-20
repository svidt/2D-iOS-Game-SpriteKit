//
//  GameScene.swift
//  2D iOS Game
//
//  Created by Kristian Emil Hansen Svidt on 17/04/2023.
//

import SpriteKit
import GameplayKit

var isGamerTouching = false

let BallCategory: UInt32 = 0x1 << 0
let BottomCategory: UInt32 = 0x1 << 1
let ShoeCategory: UInt32 = 0x1 << 2

var scoreInt: Int = 0
var scoreLabel = SKLabelNode(fontNamed: "Arial")

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        let ball = childNode(withName: "ball") as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVector(dx: 10, dy: 20))
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        let shoe = childNode(withName: "shoe") as! SKSpriteNode
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        shoe.physicsBody!.categoryBitMask = ShoeCategory
        
        ball.physicsBody!.contactTestBitMask = BottomCategory | ShoeCategory
        physicsWorld.contactDelegate = self
        
        scoreLabel.text = "Score: " + String(scoreInt)
        scoreLabel.fontSize = 25
        scoreLabel.position = CGPoint(x:(self.frame.maxX)*0.8, y:(self.frame.maxY)*0.8)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    // Added code:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == "shoe" {
                isGamerTouching = true
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGamerTouching {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            
            let previousLocation = touch!.previousLocation(in: self)
            let shoe = childNode(withName: "shoe") as! SKSpriteNode
            let shoeX = shoe.position.x + (touchLocation.x - previousLocation.x)
            shoe.position = CGPoint(x: shoeX, y: shoe.position.y)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isGamerTouching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func update(_ currentTime: TimeInterval)
    {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 4 &&
            contact.bodyB.categoryBitMask == 1 {
            
            scoreInt = scoreInt + 1
            print(scoreInt)
            scoreLabel.text = "Score: " + String(scoreInt)
        }
        
        if contact.bodyA.categoryBitMask == 2 &&
            contact.bodyB.categoryBitMask == 1 {
            
            let shoe = childNode(withName: "shoe") as! SKSpriteNode
            shoe.isHidden = true
            var myLabel: SKLabelNode!
            myLabel = SKLabelNode(fontNamed: "Arial")
            myLabel.text = "Game Over"
            myLabel.fontSize = 50
            myLabel.fontColor = SKColor.red
            myLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            myLabel.zPosition = 4
            self.addChild(myLabel)
        }
    }
    
}


//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
