import UIKit

enum ShapeType: String {
    case Triangle = "triangle";
    case Pentagon = "pentagon";
    case Square = "square";
    case Circle = "circle";
    case Cross = "cross";
    case Rounded = "rounded";
}

enum ObstacleType: String {
    case Spiral = "spiral";
    case Mill = "mill";
    case Infinity = "infinity"
}

protocol ShapeTypeSelectionDelegate {
    func didSelectThrowBodyWithImage(image: UIImage)
    func didSelectObstacleWithImage(image: UIImage)
}

protocol ClearTypeDelegate {
    func didClearObstacles()
    func didClearParticles()
}

class ShapeTypesViewController: UITableViewController {
    
    let shapes: [ShapeType] = [.Triangle, .Pentagon, .Square, .Circle, .Cross, .Rounded]
    let obstacles: [ObstacleType] = [.Spiral, .Mill, .Infinity]
    
    var delegate: ShapeTypeSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return shapes.count
        } else {
            return obstacles.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Shape types"
        } else if section == 1 {
            return "Obstacle types"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ShapeTypeCell", forIndexPath: indexPath) as! ShapeTypeCell
        var shapeName: String!
        if indexPath.section == 0 {
            shapeName = shapes[indexPath.row].rawValue
        } else if indexPath.section == 1 {
            shapeName = obstacles[indexPath.row].rawValue
        }
        
        cell.imgView.image = UIImage(named: shapeName)!
        cell.shapeTypeLabel.text = shapeName.uppercaseString
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            delegate?.didSelectThrowBodyWithImage(UIImage(named: shapes[indexPath.row].rawValue)!)
        } else if indexPath.section == 1 {
            delegate?.didSelectObstacleWithImage(UIImage(named: obstacles[indexPath.row].rawValue)!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
