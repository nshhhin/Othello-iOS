
import UIKit

class FieldCell: UICollectionViewCell {

    @IBOutlet weak var banV: UIView!

    var status: FieldStatus = .none

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setStatus(_ status: FieldStatus){
        self.status = status
    }

    func update(){
        switch status {
        case .black:
            banV.backgroundColor = .black
        case .white:
            banV.backgroundColor = .white
        default:
            banV.backgroundColor = .green
        }
    }

}

