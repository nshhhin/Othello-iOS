
import UIKit

class TopVC: UIViewController {

    @IBOutlet weak var switch1: UISegmentedControl!
    @IBOutlet weak var switch2: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! PlayVC
        
        switch switch1.selectedSegmentIndex {
        case 0:
            nextVC.player1 = .player
        case 1:
            nextVC.player1 = .cpu
        default:
            nextVC.player1 = .player
        }
        
        switch switch2.selectedSegmentIndex {
        case 0:
            nextVC.player2 = .player
        case 1:
            nextVC.player2 = .cpu
        default:
            nextVC.player1 = .player
        }
    }

}

