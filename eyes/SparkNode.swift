//
//  SParkNode.swift
//  eyes
//
//  Created by Serkan Sokmen on 25/04/16.
//  Copyright © 2016 Serkan Sokmen. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit


class SparkNode: SKSpriteNode {
    class func spark(location: CGPoint) -> SparkNode? {
        let spark = SparkNode(imageNamed: "spark")
        
        let rand = CGFloat(GKARC4RandomSource.sharedRandom().nextUniform())
        
        spark.physicsBody = SKPhysicsBody(circleOfRadius: (spark.size.width / 2.0) * rand)
        
        spark.name = "spark"
        spark.position = location
        spark.setScale(CGFloat(rand))
        spark.position = location
//        spark.lightingBitMask = 1
//        spark.shadowCastBitMask = 0
//        spark.shadowedBitMask = 0
        
        
        if let physics = spark.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.friction = 0.45
            physics.linearDamping = 0.05
            physics.angularDamping = 0.05
            physics.contactTestBitMask = spark.physicsBody!.collisionBitMask
        }
        
        //            if let particles = SKEmitterNode(fileNamed: "EyeParticle.sks") {
        //                particles.position = location
        //                addChild(particles)
        //            }
        
        return spark
    }
}
