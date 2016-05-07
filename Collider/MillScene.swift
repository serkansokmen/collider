import SpriteKit
import GameKit
import CoreMotion
import AudioKit


class MillScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var particleType: MillThrowBodyType = .Circle
    let particles = SKNode()
    
    override func didMoveToView(view: SKView) {
        
        view.ignoresSiblingOrder = false
        scene?.backgroundColor = UIColor.blackColor()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        addChild(particles)
        
//        if let obstacle = childNodeWithName("obstacle") {
//            let px = frame.width / 2
//            let py = frame.height / 2
//            obstacle.position = CGPointMake(px, py)
//        }
    }
    
    override func willMoveFromView(view: SKView) {
        motionManager.stopAccelerometerUpdates()
        super.willMoveFromView(view)
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        super.update(currentTime)
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * 5,
                                            dy: accelerometerData.acceleration.x * 5)
        }
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            let touchedNode = nodeAtPoint(location)
//            touchedNode.zPosition = 15
//            
//            let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
//            touchedNode.runAction(liftUp, withKey: "pickup")
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            let touchedNode = nodeAtPoint(location)
//            touchedNode.zPosition = 1
//            
//            let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
//            touchedNode.runAction(dropDown, withKey: "drop")
//        }
//    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let loc = touch.locationInNode(self)
            let prev = touch.previousLocationInNode(self)
            let dir = CGVector(dx: (loc.x - prev.x) * 7.5,
                               dy: (loc.y - prev.y) * 7.5)
            let body = MillThrowBody(imageNamed: particleType.description())
            body.position = loc
            body.physicsBody?.velocity = dir
            particles.addChild(body)
            
            if particles.children.count > 100 {
                let removeNode = particles.children[0]
                removeNode.removeFromParent()
//                let fade = SKAction.fadeAlphaTo(0.0, duration: 0.2)
//                removeNode.runAction(fade, withKey: "remove")
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.collisionImpulse > 1.0) {
            if let aNode = contact.bodyA.node as? MillThrowBody {
                UIView.animateWithDuration(2, animations: { _ in
                    aNode.color = UIColor.greenColor();
                })
            }
            if let bNode = contact.bodyB.node as? MillThrowBody {
                UIView.animateWithDuration(2, animations: { _ in
                    bNode.color = UIColor.redColor();
                })
            }
        }
    }

}
