
import UIKit

class TopVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapSinglePlayBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Play", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController() as! PlayVC
        nextVC.modalTransitionStyle = .flipHorizontal
        present(nextVC, animated: true)
    }

}

