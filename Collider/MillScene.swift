import SpriteKit
import GameKit
import CoreMotion
import AudioKit


class MillScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var particleType: ParticleBodyType = .Circle
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
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -5,
                                            dy: accelerometerData.acceleration.x * 5)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
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
                particles.children[0].removeFromParent()
            }
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.collisionImpulse > 1.0) {
            
        }
    }

}
