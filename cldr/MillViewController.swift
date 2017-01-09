import UIKit
import SpriteKit
import Hero
import ChameleonFramework

enum ShapeType: String {
    case triangle = "triangle"
    case pentagon = "pentagon"
    case square = "square"
    case circle = "circle"
    case cross = "cross"
    case rounded = "rounded"
    
    var thumbnail: UIImage {
        return UIImage(named: "\(self.rawValue)-sm")!
    }
    var image: UIImage {
        return UIImage(named: "\(self.rawValue)")!
    }
    
    static var shapes: [ShapeType] {
        return [.triangle, .pentagon, .square, .circle, .cross, .rounded]
    }
    static var obstacles: [ObstacleType] {
        return [.spiral, .mill, .infinity]
    }
}

enum ObstacleType: String {
    case spiral = "spiral"
    case mill = "mill"
    case infinity = "infinity"
    
    var image: UIImage {
        return UIImage(named: "\(self.rawValue)")!
    }
}

protocol ShapeManagerDelegate {
    func didAddShape(atPosition point: CGPoint, andVelocity velocity: CGVector?)
    func didClearObstacles()
    func didClearParticles()
    func didSelectThrowBody(_ type: ShapeType)
    func didSelectObstacle(_ type: ObstacleType)
}

class ShapeManager {
    
    var observer: ShapeManagerDelegate?
    
//    private var queue = [ShapeType]()
//    
//    func append(type: ShapeType) {
//        
//        self.queue.append(type)
//        
//        self.observer?.didAdd(type)
//    }
    
    func setup() {
        
    }
}


struct MillViewModel {
    var lastRotation: CGFloat
    var particleImage: UIImage?
}

class MillViewController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var shapeTypeBarButtonItem: UIBarButtonItem!
    
    //MARK: - IBActions
    
    @IBAction func tappedClearShapes(_ sender: UIBarButtonItem) {
        shapeManager?.observer?.didClearParticles()
    }
    @IBAction func tappedClearObstacles(_ sender: UIBarButtonItem) {
        shapeManager?.observer?.didClearObstacles()
    }
    
    var viewModel: MillViewModel!
    var shapeManager: ShapeManager?
    
    var statusHidden = false {
        didSet {
            navigationController?.isToolbarHidden = statusHidden
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MillViewModel(lastRotation: CGFloat(0.0), particleImage: UIImage(named: "circle-sm"))
        statusHidden = false
        navigationController?.isNavigationBarHidden = true
        navigationController?.isHeroEnabled = true
        
        shapeManager = ShapeManager()
        shapeManager?.observer = self
        shapeManager?.setup()
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        let scene = MillScene(size: skView.frame.size)
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
        
        scene.shapeManagerDelegate = self
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShapeTypesViewController {
            vc.delegate = shapeManager?.observer
        }
    }
    
}

//MARK: - Shape Type Controller Delegate
extension MillViewController: ShapeManagerDelegate {
    
    func didAddShape(atPosition point: CGPoint, andVelocity velocity: CGVector?) {
        
        guard let millScene = self.skView.scene as? MillScene else { return }
        guard let image = self.viewModel.particleImage else { return }
        
        let body = MillThrowBody.init(withImage: image, andColor: UIColor.flatBrown)
        body.position = point
        body.physicsBody?.velocity = velocity ?? CGVector.zero
        millScene.particles.addChild(body)
        
        if millScene.particles.children.count > 100 {
            millScene.particles.children[0].removeFromParent()
        }
    }
    func didSelectThrowBody(_ type: ShapeType) {
        self.viewModel.particleImage = type.image
        shapeTypeBarButtonItem.image = type.thumbnail
    }
    
    func didSelectObstacle(_ type: ObstacleType) {
        guard let millScene = self.skView.scene as? MillScene else { return }
        
        let size = min(self.view.frame.width, self.view.frame.height)
        let image = resize(type.image, toSize: CGSize(width: size/2, height: self.view.frame.size.height/2))
        let mill = MillObstacle(withImage: image, andColor: UIColor.flatBrownDark)
        mill.position = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        mill.setScale(RandomCGFloat(0.5, max: 0.8))
        mill.setupPhysics(fromImage: type.image)
        millScene.obstacles.addChild(mill)
    }
    
    func didClearObstacles() {
        guard let millScene = self.skView.scene as? MillScene else { return }
        millScene.obstacles.removeAllActions()
        millScene.obstacles.removeAllChildren()
    }
    
    func didClearParticles() {
        guard let millScene = self.skView.scene as? MillScene else { return }
        millScene.particles.removeAllActions()
        millScene.particles.removeAllChildren()
    }
}

func resize(_ image: UIImage, toSize size: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = size.width  / image.size.width
    let heightRatio = size.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
