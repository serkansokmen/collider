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
        
        let rand = RandomCGFloat(min: 0.1, max: 0.25)
        setScale(rand)
        
        switch name {
        case MillThrowBodyType.Circle.description():
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        case MillThrowBodyType.Rectangle.description():
            self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        case MillThrowBodyType.Rounded.description():
            self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        default:
            break
        }
        
        
        if let physics = self.physicsBody {
            
            physics.dynamic = true
            physics.affectedByGravity = true
            physics.allowsRotation = true
            
            physics.density = rand
            physics.friction = 0.85
            physics.restitution = 0.25
            
            physics.angularVelocity = 0.75
            physics.angularDamping = 0.01
            physics.linearDamping = 0.01
            
            physics.contactTestBitMask = physics.collisionBitMask
        }
    }
    
}