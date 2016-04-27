//
//  GameScene.swift
//  eyes
//
//  Created by Serkan Sokmen on 24/04/16.
//  Copyright (c) 2016 Serkan Sokmen. All rights reserved.
//

import SpriteKit
import GameKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sparks = [SKSpriteNode]()
    var motionManager: CMMotionManager!
    
    
    override func didMoveToView(view: SKView) {
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if let spark = SparkNode.spark(location) {
                addChild(spark)
                sparks.append(spark)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
//        for spark in sparks {
//            
//        }
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 50, dy: accelerometerData.acceleration.y * 50)
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
//        if contact.bodyA.node!.name == "spark" {
//            collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
//        }
    }
    
    override func willMoveFromView(view: SKView) {
        motionManager.stopAccelerometerUpdates()
        super.willMoveFromView(view)
    }
}
