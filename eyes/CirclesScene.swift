import SpriteKit
import GameKit
import CoreMotion
import C4


class CirclesScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var theta: Double! = nil
    var hitSound: AudioPlayer?
    
    let shapes = ["circle", "rectangle", "rounded"]
    var obstacles = [SKSpriteNode]()
    
    override func didMoveToView(view: SKView) {
        
        view.ignoresSiblingOrder = false
        view.backgroundColor = UIColor.blackColor()
        
//        let bg = SKSpriteNode(imageNamed: "background")
//        bg.size = self.size;
//        bg.zPosition = 0;
//        bg.position = CGPointMake(frame.size.width/2, frame.size.height/2);
//        bg.zPosition = -1
//        addChild(bg)
        
        let mill = createBody(atLocation: frame.origin, withImageName: "mill")
        mill.physicsBody?.dynamic = false
        obstacles.append(mill)
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        theta = 0.0
        
        hitSound = AudioPlayer("hit.wav")
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let dir = CGVector(dx: (touch.locationInNode(self).x - touch.previousLocationInNode(self).x) * 5,
                               dy: (touch.locationInNode(self).y - touch.previousLocationInNode(self).y) * 5)
            
            let chance = RandomFloat(min: -15.0, max: 15.0)
            var node: SKSpriteNode! = nil
            if chance < -5.0 {
                node = createBody(atLocation: touch.locationInNode(self), withImageName: "circle")
            } else if chance >= -5.0 && chance < 5.0 {
                node = createBody(atLocation: touch.locationInNode(self), withImageName: "rectangle")
            } else {
                node = createBody(atLocation: touch.locationInNode(self), withImageName: "rounded")
            }
            node.physicsBody?.velocity = dir
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        theta = theta + 0.01
        let radius = 5.0
        let s = sin(CGFloat(theta))
        let c = cos(CGFloat(theta))
        
        for obstacle in obstacles {
            obstacle.position.x = view!.bounds.width / 2 + CGFloat(radius) * s
            obstacle.position.y = view!.bounds.height / 2 + CGFloat(radius) * c
            obstacle.zRotation = c
        }
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 10,
                                            dy: accelerometerData.acceleration.y * 10)
        }
        
    }
    
    override func willMoveFromView(view: SKView) {
        motionManager.stopAccelerometerUpdates()
        super.willMoveFromView(view)
    }
    
    func createBody(atLocation location: CGPoint, withImageName imageName: String) -> SKSpriteNode {
        
        let rand = CGFloat(RandomFloat(min: 0.2, max: 0.5))
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName), size: sprite.size)
        
        sprite.name = imageName
        sprite.position = location
        sprite.setScale(CGFloat(rand))
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
        addChild(sprite)
        
        return sprite
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.collisionImpulse > 50.0) {
            hitSound?.volume = Double(contact.collisionImpulse) / 100.0
            hitSound?.play()
        }
//        if let particles = SKEmitterNode(fileNamed: "SparkParticle.sks") {
//            particles.position = contact.contactPoint
//            addChild(particles)
//        }
    }

}
