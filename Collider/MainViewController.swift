import UIKit
import SpriteKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsDrawCount = false
        skView.showsNodeCount = false
    }
    
}
