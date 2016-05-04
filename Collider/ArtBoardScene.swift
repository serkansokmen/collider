import SpriteKit
import GameKit
import CoreMotion
import C4


class ArtBoardScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var hitSound: AudioPlayer?
    let particles = SKNode()
    
    override func didMoveToView(view: SKView) {
        
        view.ignoresSiblingOrder = false
         scene?.backgroundColor = UIColor.blackColor()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        hitSound = AudioPlayer("hit.wav")
        
        addChild(particles)
        
        if let obstacle = childNodeWithName("obstacle") {
            let px = frame.width / 2
            let py = frame.height / 2
            obstacle.position = CGPointMake(px, py)
        }
    }
    
    override func willMoveFromView(view: SKView) {
        motionManager.stopAccelerometerUpdates()
        super.willMoveFromView(view)
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        super.update(currentTime)
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 15,
                                            dy: accelerometerData.acceleration.y * 15)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let dir = CGVector(dx: (touch.locationInNode(self).x - touch.previousLocationInNode(self).x) * 25,
                               dy: (touch.locationInNode(self).y - touch.previousLocationInNode(self).y) * 25)
            
            var imageName: String! = nil
            let chance = RandomDouble(min: -1.5, max: 1.5)
            
            if chance <= -0.5 {
                imageName = "circle"
            } else if chance > -0.5 && chance <= 0.5 {
                imageName = "rounded"
            } else {
                imageName = "rectangle"
            }
            
            let node = createBody(atLocation: touch.locationInNode(self), withImageName: imageName)
            node.physicsBody?.velocity = dir
        }
    }
    
    
    func createBody(atLocation location: CGPoint, withImageName imageName: String) -> SKSpriteNode {
        
        let rand = RandomCGFloat(min: 0.15, max: 0.45)
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName), size: sprite.size)
        
        sprite.name = imageName
        sprite.position = location
        sprite.setScale(rand)
        sprite.zPosition = 1
        
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.friction = 0.85
            physics.angularVelocity = 0.75
            physics.linearDamping = 0.01
            physics.angularDamping = 0.01
            physics.contactTestBitMask = sprite.physicsBody!.collisionBitMask
        }
        particles.addChild(sprite)
        if particles.children.count > 100 {
            particles.children[0].removeFromParent()
        }
        
        return sprite
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.collisionImpulse > 50.0) {
            hitSound?.volume = Double(contact.collisionImpulse) / 100.0
            hitSound?.play()
        }
    }

}
