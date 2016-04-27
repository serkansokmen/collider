import SpriteKit
import GameKit
import CoreMotion
import C4


class CirclesScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    var theta: Double! = nil
    var hitSound: AudioPlayer?
    
    let shapes = ["circle", "rectangle", "rounded"]
    
    override func didMoveToView(view: SKView) {
        
        view.ignoresSiblingOrder = false
        view.backgroundColor = UIColor.blackColor()
        
//        let bg = SKSpriteNode(imageNamed: "background")
//        bg.size = self.size;
//        bg.zPosition = 0;
//        bg.position = CGPointMake(frame.size.width/2, frame.size.height/2);
//        bg.zPosition = -1
//        addChild(bg)
        
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
            addChild(node)
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
        let spark = SKSpriteNode(imageNamed: imageName)
        spark.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName), size: spark.size)
        
        spark.name = imageName
        spark.position = location
        spark.setScale(CGFloat(rand))
        spark.zPosition = 1
        
        if let physics = spark.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.friction = 0.85
            physics.angularVelocity = 0.75
            physics.linearDamping = 0.01
            physics.angularDamping = 0.01
            physics.contactTestBitMask = spark.physicsBody!.collisionBitMask
        }
        
        return spark
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
