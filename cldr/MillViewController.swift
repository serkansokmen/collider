import UIKit
import SpriteKit

struct MillViewModel {
    var lastRotation: CGFloat
}

class MillViewController: UIViewController, ShapeTypeSelectionDelegate, ClearTypeDelegate {
    
    var viewModel: MillViewModel!
    var clearDelegate: ClearTypeDelegate?
    
    var statusHidden = false {
        didSet {
            navigationController?.isToolbarHidden = statusHidden
        }
    }
    
    @IBOutlet weak var skView: SKView!
    
    //MARK: - Settings Popup Delegate
    func didSelectThrowBodyWithImage(_ image: UIImage) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.particleImage = image
        }
    }
    
    func didSelectObstacleWithImage(_ image: UIImage) {
        if let millScene = self.skView.scene as? MillScene {
            millScene.addObstacle(withImage: image,
                                  atPosition: CGPoint(x: view.frame.width/2, y: view.frame.height/2))
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
    
    @IBAction func tappedClearShapes(_ sender: UIBarButtonItem) {
        clearDelegate?.didClearParticles()
    }
    @IBAction func tappedClearObstacles(_ sender: UIBarButtonItem) {
        clearDelegate?.didClearObstacles()
    }
    
    @IBAction func rotated(_ sender: UIRotationGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.ended) {
            viewModel.lastRotation = 0.0;
            return
        }
        
        let rotation = 0.0 - (sender.rotation - viewModel.lastRotation)
        let trans = CGAffineTransform(rotationAngle: rotation)
        
        if let skScene = skView.scene {
            let newGravity = CGPoint(x: skScene.physicsWorld.gravity.dy, y: skScene.physicsWorld.gravity.dx).applying(trans)
            skScene.physicsWorld.gravity = CGVector(dx: newGravity.x, dy: newGravity.y)
        }
        
        viewModel.lastRotation = sender.rotation
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MillViewModel(lastRotation: CGFloat(0.0))
        clearDelegate = self
        statusHidden = false
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        let scene = MillScene(size: skView.frame.size)
        scene.scaleMode = .aspectFit
        scene.particleImage = UIImage(named: "circle-sm")
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShapeTypesViewController {
            vc.delegate = self
        }
    }
    
}
