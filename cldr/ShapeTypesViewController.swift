import UIKit

enum ShapeType: String {
    case Triangle = "triangle"
    case Pentagon = "pentagon"
    case Square = "square"
    case Circle = "circle"
    case Cross = "cross"
    case Rounded = "rounded"
}

enum ObstacleType: String {
    case Spiral = "spiral"
    case Mill = "mill"
    case Infinity = "infinity"
}

protocol ShapeTypeSelectionDelegate {
    func didSelectThrowBodyWithImage(_ image: UIImage)
    func didSelectObstacleWithImage(_ image: UIImage)
}

protocol ClearTypeDelegate {
    func didClearObstacles()
    func didClearParticles()
}

class ShapeTypesViewController: UIViewController {
    
    let shapes: [ShapeType] = [.Triangle, .Pentagon, .Square, .Circle, .Cross, .Rounded]
    let obstacles: [ObstacleType] = [.Spiral, .Mill, .Infinity]
    
    var delegate: ShapeTypeSelectionDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ShapeTypesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return shapes.count
        } else {
            return obstacles.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Shape types"
        } else if section == 1 {
            return "Obstacle types"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShapeTypeCell", for: indexPath) as! ShapeTypeCell
        var shapeName: String!
        if (indexPath as NSIndexPath).section == 0 {
            shapeName = shapes[(indexPath as NSIndexPath).row].rawValue
            //            cell.backgroundColor = UIColor.flatRed()
        } else if (indexPath as NSIndexPath).section == 1 {
            shapeName = obstacles[(indexPath as NSIndexPath).row].rawValue
            //            cell.backgroundColor = UIColor.flatLime()
        }
        
        cell.imgView.image = UIImage(named: shapeName)!
        cell.shapeTypeLabel.text = shapeName.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            delegate?.didSelectThrowBodyWithImage(UIImage(named: shapes[(indexPath as NSIndexPath).row].rawValue)!)
        } else if (indexPath as NSIndexPath).section == 1 {
            delegate?.didSelectObstacleWithImage(UIImage(named: obstacles[(indexPath as NSIndexPath).row].rawValue)!)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
