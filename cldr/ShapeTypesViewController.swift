import UIKit

class ShapeTypesViewController: UIViewController {
    
    var delegate: ShapeManagerDelegate?
    
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
            return ShapeType.shapes.count
        } else {
            return ShapeType.obstacles.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Shapes"
        } else if section == 1 {
            return "Obstacles"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShapeTypeCell", for: indexPath) as! ShapeTypeCell
        var shapeName: String!
        if (indexPath as NSIndexPath).section == 0 {
            shapeName = ShapeType.shapes[(indexPath as NSIndexPath).row].rawValue
            //            cell.backgroundColor = UIColor.flatRed()
        } else if (indexPath as NSIndexPath).section == 1 {
            shapeName = ShapeType.obstacles[(indexPath as NSIndexPath).row].rawValue
            //            cell.backgroundColor = UIColor.flatLime()
        }
        
        cell.imgView.image = UIImage(named: shapeName)!
        cell.shapeTypeLabel.text = shapeName.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            delegate?.didSelectThrowBody(ShapeType.shapes[(indexPath as NSIndexPath).row])
        } else if (indexPath as NSIndexPath).section == 1 {
            delegate?.didSelectObstacle(ShapeType.obstacles[(indexPath as NSIndexPath).row])
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}
