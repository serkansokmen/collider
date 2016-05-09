import SpriteKit


class MillThrowBody: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let types: [String] = ["circle", "square", "triangle", "pentagon", "cross", "rounded"]
    
    init(imageNamed name: String) {
        
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture,
                   color: UIColor.whiteColor(),
                   size: texture.size())
        
        self.name = name
        self.zPosition = 1
        
        let rand = RandomCGFloat(min: 0.1, max: 0.25)
        setScale(rand)
        
        if let type = MillThrowBody.types.indexOf(name) {
            switch type {
            case 0:
                self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
            case 1:
                self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
            default:
                self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
            }
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