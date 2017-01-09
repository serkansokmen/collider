import SpriteKit
import GameKit
import CoreMotion


class MillScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager: CMMotionManager!
    let particles = SKNode()
    let obstacles = SKNode()
    var activeSlicePoints = [CGPoint]()
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var shapeManagerDelegate: ShapeManagerDelegate?
    
    override func didMove(to view: SKView) {
        
        view.ignoresSiblingOrder = false
        scene?.backgroundColor = .flatSand
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        createSlices()
        
        addChild(particles)
        addChild(obstacles)
    }
    
    override func willMove(from view: SKView) {
        motionManager.stopAccelerometerUpdates()
        super.willMove(from: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        super.update(currentTime)
        
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -5,
                                            dy: accelerometerData.acceleration.x * 5)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            activeSlicePoints.append(location)
            
            redrawActiveSlice()
            
            activeSliceBG.removeAllActions()
            activeSliceFG.removeAllActions()
            
            activeSliceBG.alpha = 1
            activeSliceFG.alpha = 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            activeSlicePoints.append(location)
            
            let loc = touch.location(in: self)
            let prev = touch.previousLocation(in: self)
            let dir = CGVector(dx: (loc.x - prev.x) * 7.5,
                               dy: (loc.y - prev.y) * 7.5)
            
            shapeManagerDelegate?.didAddShape(atPosition: loc, andVelocity: dir)
        }
        
        redrawActiveSlice()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.collisionImpulse > 0.1) {
            
            if let _ = contact.bodyA.node as? MillThrowBody,
                let _ = contact.bodyB.node as? MillThrowBody {
                playCollisionSound()
            }
        }
    }
    
    func playCollisionSound() {
//        let interval: Double = 1
//        let numberOfNotes: Double = 1
//        let startingNote: Double = 96 // C
//        let frequency = (floor(AKOperation.phasor(frequency: 0.5) * numberOfNotes) * interval  + startingNote).midiNoteToFrequency()
//        let amplitude = (AKOperation.phasor(frequency: 0.5) - 1).portamento() // prevents the click sound
//        
//        let oscillator = AKOperation.morphingOscillator(frequency: frequency, amplitude: amplitude)
//        let reverb = oscillator.reverberateWithFlatFrequencyResponse()
//        let oscillatorReverbMix = mixer(oscillator, reverb, balance: 0.6)
//        let generator = AKOperationGenerator(operation: oscillatorReverbMix)
//        
//        AudioKit.output = generator
//        generator.start()
//        AudioKit.start()
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 2
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 3
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 1
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        while activeSlicePoints.count > 12 {
            activeSlicePoints.remove(at: 0)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }

}
