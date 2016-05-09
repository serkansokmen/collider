import Foundation
import SpriteKit


class MillViewController: UIViewController {
    
    var lastRotation = CGFloat(0.0)
    var skView: SKView! = nil
    var particleType: String = MillThrowBody.types[0]
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        
        let ac = UIAlertController(title: "Particle type", message: nil, preferredStyle: .ActionSheet)
        for type in MillThrowBody.types {
            ac.addAction(UIAlertAction(title: type, style: .Default, handler: { _ in
                if let millScene = self.skView.scene as? MillScene {
                    millScene.particleType = type
                }
            }))
        }
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
        
//        var sceneName: String = ""
        let scene = MillScene(fileNamed: "MillScene.sks")
        scene?.scaleMode = .AspectFit
        scene?.particleType = particleType
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
