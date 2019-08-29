
import Foundation
import UIKit

class FieldCell: UICollectionViewCell {
    
    @IBOutlet weak var panelV: UIView! {
        didSet {
            // 円にならん
            panelV.frame.size.width = self.frame.width
            panelV.frame.size.height = self.frame.height
            panelV.layer.cornerRadius = self.frame.width/3
            panelV.clipsToBounds = true
            panelV.backgroundColor = .green
        }
    }
    
    func updateColor(_ status: PanelStatus){
        switch status {
        case .none:
            panelV.backgroundColor = .green
        case .black:
            panelV.backgroundColor = .black
        case .white:
            panelV.backgroundColor = .white
        }
    }
    
}
