import SpriteKit
import GameKit
import AudioKit


class MillThrowBody: SKSpriteNode {
    
    let collisionSound = AKDrip(intensity: 1)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withImage image: UIImage) {
        
        let texture = SKTexture(image: image)
        super.init(texture: texture,
                   color: UIColor.whiteColor(),
                   size: texture.size())
        
        self.name = name
        self.zPosition = 1
        let rand = RandomCGFloat(min: 0.6, max: 1.0)
        self.xScale = rand
        self.yScale = rand
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        
        if let physics = self.physicsBody {
            
            physics.dynamic = true
            physics.affectedByGravity = true
            physics.allowsRotation = true
            
            physics.density = min(xScale, yScale)
            physics.friction = 0.85
            physics.restitution = 0.25
            
            physics.angularVelocity = 0.75
            physics.angularDamping = 0.01
            physics.linearDamping = 0.01
            
            physics.contactTestBitMask = physics.collisionBitMask
        }
    }
    
}