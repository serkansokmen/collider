import UIKit
import SpriteKit


class MillThrowBody: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed name: String) {
        
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture,
                   color: UIColor.whiteColor(),
                   size: texture.size())
        
        self.name = name
        self.zPosition = 1
        
        let rand = RandomCGFloat(min: 0.1, max: 0.5)
        setScale(rand)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        if let physics = self.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.mass = rand
            physics.friction = 0.35
            physics.restitution = 0.4
            physics.angularVelocity = 0.75
            physics.linearDamping = 0.01
            physics.angularDamping = 0.01
            physics.contactTestBitMask = physics.collisionBitMask
        }
    }
    
}