
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
        arrayPanels[3][4] = .black
        arrayPanels[4][3] = .black
        arrayPanels[4][4] = .white
        
        updateUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fieldWidth * fieldWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FieldCell", for: indexPath) as! FieldCell
        let x = Int(indexPath.row/fieldWidth)
        let y = (indexPath.row%fieldWidth)
        let panelStatus = arrayPanels[x][y]
        cell.updateColor(panelStatus)
        
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
        let x = Int(indexPath.row/fieldWidth)
        let y = indexPath.row%fieldWidth
        
        switch turnStatus {
        case .black:
            if isPuttable(.black, x: x, y: y) {
                put(.black, x: x, y: y)
                turnStatus = .white
            }
        case .white:
            if isPuttable(.white, x: x, y: y) {
                put(.white, x: x, y: y)
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
    
    func isNot(_ status: PanelStatus) -> PanelStatus {
        switch status {
        case .black:
            return .white
        case .white:
            return .black
        case .none:
            return .none
        }
    }
    
    func currentPanel(_ status: TurnStatus) -> PanelStatus {
        switch status {
        case .black:
            return .black
        case .white:
            return .white
        }
    }
    
    func isPuttable(_ putPanelStatus:PanelStatus, x: Int, y: Int) -> Bool {
    
        // もう置いてあったら置けない
        if arrayPanels[x][y] != .none {
            return false
        }
        // 周辺の状況をしらべる
        var isRoundExist = false
        for dx in -1..<2 {
        for dy in -1..<2 {
            if dx == 0 && dy == 0 {
               continue
            }
            let isOverField = x + dx < 0 || y + dy < 0 || x + dx >= fieldWidth || y + dy >= fieldWidth
            if isOverField {
                continue
            }
            if arrayPanels[x+dx][y+dy] == isNot(putPanelStatus) {
                isRoundExist = searchNeighbor(x: x, y: y, dx: dx, dy: dy) || isRoundExist
            }
        }
        }
        return isRoundExist
    }
    
    func searchNeighbor(x: Int, y:Int, dx: Int, dy: Int) -> Bool {
        let isOverField = x + dx < 0 || y + dy < 0 || x + dx >= fieldWidth || y + dy >= fieldWidth
        if isOverField {
            return false
        }
        
        if arrayPanels[x+dx][y+dy] == currentPanel(turnStatus) {
            return true
        } else if arrayPanels[x+dx][y+dy] == .none {
            return false
        } else {
            return searchNeighbor(x: x+dx, y: y+dy, dx: dx, dy: dy)
        }
    }
    
    func put(_ putPanelStatus:PanelStatus, x: Int, y: Int){
        
        arrayPanels[x][y] = putPanelStatus
        
         var isRoundExist = false

        for dx in -1..<2 {
        for dy in -1..<2 {
            if dx == 0 && dy == 0 {
                continue
            }
            let isOverField = x + dx < 0 || y + dy < 0 || x + dx >= fieldWidth || y + dy >= fieldWidth
            if isOverField {
                continue
            }
            
            // 各方向が何個ひっくり返せるかを数える
            let t = reverseCount(x: x, y: y, dx: dx, dy: dy, count: 0)
            for i in 0..<t+1 {
                arrayPanels[x+dx*i][y+dy*i] = currentPanel(turnStatus)
            }
        }}
    }
    
    func reverseCount(x: Int, y: Int, dx: Int, dy: Int, count: Int) -> Int {
        if arrayPanels[x+dx][y+dy] == currentPanel(turnStatus) {
            return count
        } else if arrayPanels[x+dx][y+dy] == .none {
            return 0
        } else {
            return reverseCount(x: x+dx, y: y+dy, dx: dx, dy: dy, count: count+1)
        }
    }
    
}

