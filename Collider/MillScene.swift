import SpriteKit
import GameKit
import CoreMotion


class MillScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var particleType: String! = ""
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
    }
    
    func typeSelected(type: String) {
        self.particleType = type
    }
    
    override func willMoveFromView(view: SKView) {
        motionManager.stopAccelerometerUpdates()
        super.willMoveFromView(view)
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        super.update(currentTime)
        
        if let accelerometerData = motionManager.accelerometerData {
            switch UIDevice.currentDevice().orientation {
            case .Portrait:
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 5,
                                                dy: accelerometerData.acceleration.y * 5)
            case .PortraitUpsideDown:
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 5,
                                                dy: accelerometerData.acceleration.y * -5)
            case .LandscapeRight:
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * 5,
                                                dy: accelerometerData.acceleration.x * -5)
            case .LandscapeLeft:
                physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * 5,
                                                dy: accelerometerData.acceleration.x * 5)
            default:
                break
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let loc = touch.locationInNode(self)
            let prev = touch.previousLocationInNode(self)
            let dir = CGVector(dx: (loc.x - prev.x) * 7.5,
                               dy: (loc.y - prev.y) * 7.5)
            let body = MillThrowBody(imageNamed: particleType)
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
