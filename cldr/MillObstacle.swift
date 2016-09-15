import SpriteKit


class MillObstacle: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withImage image: UIImage) {
        
        let texture = SKTexture(image: image)
        super.init(texture: texture,
                   color: UIColor.white,
                   size: texture.size())
        self.name = name
        self.zPosition = 1
    }
    
    func setupPhysics(fromImage image: UIImage) {
        let texture = SKTexture(image: image)
        physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        if let physics = self.physicsBody {
            
            physics.isDynamic = true
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.pinned = true
            physics.density = 0.75
            physics.friction = 0.85
            physics.restitution = 0.25
            
            physics.angularVelocity = 0.15
            physics.angularDamping = 0.95
            physics.linearDamping = 0.75
            
            physics.contactTestBitMask = physics.collisionBitMask
        }
    }
    
}
