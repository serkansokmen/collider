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


class GameScene: SKScene {
    
    var motionManager: CMMotionManager!
    var theta: Double! = nil
    
    override func didMoveToView(view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "background")
        bg.size = self.size;
        bg.zPosition = 0;
        bg.position = CGPointMake(frame.size.width/2, frame.size.height/2);
        bg.zPosition = -1
        addChild(bg)
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        theta = 0.0
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            spark(atLocation: touch.locationInNode(self))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        theta = theta + 0.001
        let radius = min(frame.width, frame.height) / 2
        if let light = childNodeWithName("SceneLight") {
            light.position.x = CGFloat(radius) * sin(CGFloat(theta))
            light.position.y = CGFloat(radius) * cos(CGFloat(theta))
            print(light.position)
        }
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 50, dy: accelerometerData.acceleration.y * 50)
        }
        
    }
    
    override func willMoveFromView(view: SKView) {
        motionManager.stopAccelerometerUpdates()
        super.willMoveFromView(view)
    }
    
    func spark(atLocation location: CGPoint) {
        
        let spark = SKSpriteNode(imageNamed: "spark")
//        let rand = CGFloat(GKARC4RandomSource.sharedRandom().nextUniform())
        
        spark.physicsBody = SKPhysicsBody(circleOfRadius: (spark.size.width / 2.0))
        
        spark.name = "spark"
        spark.position = location
//        spark.setScale(CGFloat(rand))
//        spark.lightingBitMask = 1
//        spark.shadowCastBitMask = 1
//        spark.shadowedBitMask = 1
        spark.zPosition = 1
        
        
        
        
        if let physics = spark.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.friction = 0.45
            physics.linearDamping = 0.05
            physics.angularDamping = 0.05
            physics.contactTestBitMask = spark.physicsBody!.collisionBitMask
        }
        
        if let particles = SKEmitterNode(fileNamed: "SparkParticle.sks") {
            particles.position = location
            addChild(particles)
        }
        
        addChild(spark)
    }

}
