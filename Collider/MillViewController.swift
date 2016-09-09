import UIKit
import SpriteKit


class MillViewController: UIViewController, ShapeTypeSelectionDelegate, ClearTypeDelegate {
    
    var clearDelegate: ClearTypeDelegate?
    var lastRotation = CGFloat(0.0)
    
    @IBOutlet weak var skView: SKView!
    
    //MARK: - Settings Popup Delegate
    func didSelectThrowBodyWithImage(image: UIImage) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particleImage = image
        }
    }
    func didSelectObstacleWithImage(image: UIImage) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.addObstacle(withImage: image,
                                  atPosition: CGPointMake(view.frame.width/2, view.frame.height/2))
        }
    }
    
    func didClearObstacles() {
        if let millScene = self.skView.scene as? MillScene {
            millScene.obstacles.removeAllActions()
            millScene.obstacles.removeAllChildren()
        }
    }
    
    func didClearParticles() {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particles.removeAllActions()
            millScene.particles.removeAllChildren()
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func tappedClearShapes(sender: UIBarButtonItem) {
        clearDelegate?.didClearParticles()
    }
    @IBAction func tappedClearObstacles(sender: UIBarButtonItem) {
        clearDelegate?.didClearObstacles()
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
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearDelegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        let scene = MillScene(size: skView.frame.size)
        scene.scaleMode = .AspectFit
        scene.particleImage = UIImage(named: "circle-sm")
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ShapeTypesViewController {
            vc.delegate = self
        }
    }
    
}
