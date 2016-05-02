import UIKit
import SpriteKit
import C4


enum ParticleType {
    case Circle, Rectangle, Rounded
}


class ArtBoardViewController: UIViewController {
    
    var lastRotation = CGFloat(0.0)
    let scenes = ["Scene01Mill.sks"]
    var skView: SKView! = nil
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        let ac = UIAlertController(title: "Layout", message: nil, preferredStyle: .ActionSheet)
        for fileName in scenes {
            ac.addAction(UIAlertAction(title: fileName, style: .Default, handler: { action in
                self.presentScene(fileNamed: fileName)
            }))
        }
        
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
        
        let skView = self.view as! SKView
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
        
        presentScene(fileNamed: scenes[0])
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func presentScene(fileNamed name: String) {
        let scene = ArtBoardScene(fileNamed: name)
        scene!.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
}
