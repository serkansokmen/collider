import Foundation
import SpriteKit


enum MillThrowBodyType {
    case Circle, Rectangle, Rounded
    
    func description() -> String {
        switch self {
        case .Circle:
            return "circle"
        case .Rectangle:
            return "rectangle"
        case .Rounded:
            return "rounded"
        }
    }
}

protocol BodyTypeSelectionDelegate: class {
    func typeSelected(type: MillThrowBodyType)
}


class MillViewController: UIViewController {
    
    var lastRotation = CGFloat(0.0)
    var skView: SKView! = nil
    var particleType: MillThrowBodyType = .Circle
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        
        toolbar.hidden = !toolbar.hidden
    }
    @IBAction func circleHandler(sender: UIBarButtonItem) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particleType = .Circle
        }
    }
    @IBAction func rectangleHandler(sender: UIBarButtonItem) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particleType = .Rectangle
        }
    }
    @IBAction func roundedHandler(sender: UIBarButtonItem) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particleType = .Rounded
        }
    }
    @IBAction func clearHandler(sender: AnyObject) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particles.removeAllChildren()
        }
    }
    
    
    @IBAction func rotated(sender: UIRotationGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            lastRotation = 0.0;
            return
        }
        
        let rotation = 0.0 - (sender.rotation - lastRotation)
        let trans = CGAffineTransformMakeRotation(rotation)
        
        if let skScene = skView.scene {
            let newGravity = CGPointApplyAffineTransform(CGPointMake(skScene.physicsWorld.gravity.dy, skScene.physicsWorld.gravity.dx), trans)
            skScene.physicsWorld.gravity = CGVectorMake(newGravity.x, newGravity.y)
        }
        
        lastRotation = sender.rotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        let scene = MillScene(fileNamed: "MillScene.sks")
        scene?.scaleMode = .AspectFill
        scene?.particleType = particleType
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
