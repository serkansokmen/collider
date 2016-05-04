import UIKit
import SpriteKit
import C4


enum ParticleBodyType {
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


class MillViewController: UIViewController {
    
    var lastRotation = CGFloat(0.0)
    var skView: SKView! = nil
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        let ac = UIAlertController(title: "Select a particle type", message: nil, preferredStyle: .ActionSheet)
        
        ac.addAction(UIAlertAction(title: "Circle", style: .Default, handler: { action in
            if let millScene = self.skView.scene as? MillScene {
                millScene.particleType = .Circle
            }
        }))
        ac.addAction(UIAlertAction(title: "Rectangle", style: .Default, handler: { action in
            if let millScene = self.skView.scene as? MillScene {
                millScene.particleType = .Rectangle
            }
        }))
        ac.addAction(UIAlertAction(title: "Rounded Rectangle", style: .Default, handler: { action in
            if let millScene = self.skView.scene as? MillScene {
                millScene.particleType = .Rounded
            }
        }))
        ac.addAction(UIAlertAction(title: "Clear", style: .Default, handler: { action in
            if let millScene = self.skView.scene as? MillScene {
                millScene.particles.removeAllChildren()
            }
        }))
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let popover = ac.popoverPresentationController
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: screenSize.width/2 - 32, y: 32, width: 64, height: 64)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    @IBAction func rotated(sender: UIRotationGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            lastRotation = 0.0;
            return
        }
        
        let rotation = 0.0 - (sender.rotation - lastRotation)
        let trans = CGAffineTransformMakeRotation(rotation)
        
        if let skScene = skView.scene {
            let newGravity = CGPointApplyAffineTransform(CGPointMake(skScene.physicsWorld.gravity.dx, skScene.physicsWorld.gravity.dy), trans)
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
        scene!.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
