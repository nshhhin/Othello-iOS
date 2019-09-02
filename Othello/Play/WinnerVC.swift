
import UIKit

class WinnerVC: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var winner: PanelStatus = .none
    
    override func viewDidLoad() {
        updateUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけてOKです
        let location = touch.location(in: self.view)
        
        let popUpView: UIView = self.view.viewWithTag(100)! as UIView
        
        if !popUpView.frame.contains(location) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func updateUI(){
        if winner == .black {
            textLabel.text = "黒の勝利です"
        }
        else if winner == .white {
            textLabel.text = "白の勝利です"
        }
        else {
            textLabel.text = "引き分けです"
        }
    }
}

