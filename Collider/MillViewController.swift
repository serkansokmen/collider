import UIKit
import SpriteKit


class MillViewController: UIViewController {
    
    var lastRotation = CGFloat(0.0)
    var skView: SKView! = nil
    
    @IBAction func handleMillObstacle(sender: UIBarButtonItem) {
        if let millScene = self.skView.scene as? MillScene {
            let obstacleImage = UIImage(named: "mill")
            millScene.addObstacle(withImage: obstacleImage!,
                                  atPosition: CGPointMake(view.frame.width/2, view.frame.height/2))
        }
    }
    @IBAction func handleSpiralObstacle(sender: UIBarButtonItem) {
        if let millScene = self.skView.scene as? MillScene {
            let obstacleImage = UIImage(named: "spiral")
            millScene.addObstacle(withImage: obstacleImage!,
                                  atPosition: CGPointMake(view.frame.width/2, view.frame.height/2))
        }
    }
    @IBAction func handleClearParticles(sender: UIBarButtonItem) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particles.removeAllActions()
            millScene.particles.removeAllChildren()
        }
    }
    @IBAction func handleClearObstacles(sender: UIBarButtonItem) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.obstacles.removeAllActions()
            millScene.obstacles.removeAllChildren()
        }
    }
    
    @IBAction func handleTypeTapped(sender: UIBarButtonItem) {
        
//        let ac = UIAlertController(title: nil, message: "Options", preferredStyle: .ActionSheet)
//        
        if let millScene = self.skView.scene as? MillScene {
            millScene.particleImage = sender.image
//            for type in MillThrowBody.types {
//                let typeAction = UIAlertAction(title: type.capitalizedString, style: .Default, handler: { action in
//                    millScene.particleType = action.title?.lowercaseString
//                })
//                ac.addAction(typeAction)
//            }
//            
//            let clearAction = UIAlertAction(title: "Clear", style: .Default, handler: { _ in
//                millScene.particles.removeAllChildren()
//                self.dismissViewControllerAnimated(true, completion: nil)
//            })
//            ac.addAction(clearAction)
//            ac.popoverPresentationController?.sourceView = self.view
//            ac.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
//            
//            presentViewController(ac, animated: true, completion: nil)
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
        
        let scene = MillScene(size: view.frame.size)
        scene.scaleMode = .AspectFit
        scene.particleImage = UIImage(named: "circle-sm")
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
