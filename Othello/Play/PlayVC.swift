
import UIKit

class PlayVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var arrayPanels: [[PanelStatus]] = []
    var turnStatus: TurnStatus = .black
    let fieldWidth = 8
    let margin = 1.0
    
    @IBOutlet weak var displayTurnV: UIView!
    @IBOutlet weak var displayTurnLabel: UILabel!
    
    @IBOutlet weak var filedCollectionV: UICollectionView! {
        didSet {
            filedCollectionV.delegate = self
            filedCollectionV.dataSource = self
            filedCollectionV.register(
                UINib(nibName: "FieldCell", bundle: nil),
                forCellWithReuseIdentifier: "FieldCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // フィールドを初期化
        for i in 0..<fieldWidth {
            var rowPanels: [PanelStatus] = []
            for j in 0..<fieldWidth {
                rowPanels.append(.none)
            }
            arrayPanels.append( rowPanels )
        }
        
        arrayPanels[3][3] = .white
        arrayPanels[4][3] = .black
        arrayPanels[3][4] = .black
        arrayPanels[4][4] = .white
        
        updateUI()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fieldWidth * fieldWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FieldCell", for: indexPath) as! FieldCell
        print( )
        if arrayPanels[0][0] != nil {
            let panelStatus = arrayPanels[Int(indexPath.row/fieldWidth)][indexPath.row%fieldWidth]
            cell.updateColor(panelStatus)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //　横幅を画面サイズの約半分にする
        let cellSize:CGFloat = (self.view.bounds.width - CGFloat(margin) * (CGFloat(fieldWidth) - 1.0) )/CGFloat(fieldWidth)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch turnStatus {
        case .black:
            if isPuttable(.black, indexPath) {
                put(.black, indexPath)
                turnStatus = .white
            }
        case .white:
            if isPuttable(.white, indexPath) {
                put(.white, indexPath)
                turnStatus = .black
            }
        }
        filedCollectionV.reloadData()
        updateUI()
    }
    
    func updateUI(){
        switch turnStatus {
        case .black:
            displayTurnV.backgroundColor = .black
            displayTurnLabel.textColor = .white
        case .white:
            displayTurnV.backgroundColor = .white
            displayTurnLabel.textColor = .black
        }
    }
    
    func isNot(_ status:PanelStatus) -> PanelStatus {
        switch status {
        case .black:
            return .white
        case .white:
            return .black
        case .none:
            return .none
        }
    }
    
    func isPuttable(_ putPanelStatus:PanelStatus, _ indexPath: IndexPath) -> Bool {
        
        // もう置いてあったら置けない
        if arrayPanels[Int(indexPath.row/fieldWidth)][(indexPath.row%fieldWidth)] != .none {
            return false
        }
       
        // 周辺の状況をしらべる
        var isRoundExist = false
        for dx in -1..<2 {
        for dy in -1..<2 {
            if arrayPanels[Int(indexPath.row/fieldWidth)+dx][(indexPath.row%fieldWidth)+dy] == isNot(putPanelStatus) {
                isRoundExist = isRoundExist || true
            }
        }
        }
        return isRoundExist
    }
    
    func put(_ putPanelStatus:PanelStatus, _ indexPath: IndexPath){
        arrayPanels[Int(indexPath.row/fieldWidth)][indexPath.row%fieldWidth] = putPanelStatus
    }
    
}

