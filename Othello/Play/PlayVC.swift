
import UIKit

class PlayVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var arrayPanels: [[PanelStatus]] = []
    var turnStatus: TurnStatus = .black
    var player1: PlayerStatus = .player
    var player2: PlayerStatus = .player
    let fieldWidth = 8
    let margin = 1.0
    
    @IBOutlet weak var blackCountLabel: UILabel!
    @IBOutlet weak var whiteCountLabel: UILabel!
    
    @IBOutlet weak var blackV: UIView!
    @IBOutlet weak var whiteV: UIView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
                turnStatus = currentTurn(checkPutPlace(.white))
            }
        case .white:
            if isPuttable(.white, x: x, y: y) {
                put(.white, x: x, y: y)
                turnStatus = currentTurn(checkPutPlace(.black))
            }
        }
        filedCollectionV.reloadData()
        updateUI()
    }
    
    func updateUI(){
        switch turnStatus {
        case .black:
            blackV.alpha = 1
            UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseIn, .repeat, .autoreverse], animations: {
                self.blackV.alpha = 0.3
            })
            whiteV.alpha = 1
            whiteV.layer.removeAllAnimations()
        case .white:
            whiteV.alpha = 1
            UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseIn, .repeat, .autoreverse], animations: {
                self.whiteV.alpha = 0.3
            })
            blackV.layer.removeAllAnimations()
            blackV.alpha = 1
        }
        
        var blackCount = 0
        var whiteCount = 0
        
        for i in 0..<fieldWidth {
        for j in 0..<fieldWidth {
            let panel = arrayPanels[i][j]
            switch panel {
            case .black:
                blackCount+=1
            case .white:
                whiteCount+=1
            case .none:
                break
            }
        }}
        
        blackCountLabel.text = String(blackCount)
        whiteCountLabel.text = String(whiteCount)
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
    
    func currentTurn(_ status: PanelStatus) -> TurnStatus {
        switch status {
        case .black:
            return .black
        case .white:
            return .white
        case .none:
            return .black
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
        var revSumCount = 0
        for dx in -1..<2 {
        for dy in -1..<2 {
            if dx == 0 && dy == 0 {
               continue
            }
            revSumCount += reverseCount(x: x, y: y, dx: dx, dy: dy, count: 0)
        }
        }
        
        if revSumCount > 0 {
            return true
        }
        
        return false
    }
    
    func put(_ putPanelStatus:PanelStatus, x: Int, y: Int){
        
        arrayPanels[x][y] = putPanelStatus
        
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
    
    // 何個返せるかを取得
    func reverseCount(x: Int, y: Int, dx: Int, dy: Int, count: Int) -> Int {
        let isOverField = x + dx < 0 || y + dy < 0 || x + dx >= fieldWidth || y + dy >= fieldWidth
        if isOverField {
            return 0
        }
        
        if arrayPanels[x+dx][y+dy] == currentPanel(turnStatus) {
            return count
        } else if arrayPanels[x+dx][y+dy] == .none {
            return 0
        } else {
            return reverseCount(x: x+dx, y: y+dy, dx: dx, dy: dy, count: count+1)
        }
    }
    
    func checkPutPlace(_ status: PanelStatus) -> PanelStatus {
        var existPutPlace = false
        for x in 0..<fieldWidth {
            for y in 0..<fieldWidth {
                existPutPlace = isPuttable(status, x: x, y: y) || existPutPlace
            }
        }
        if existPutPlace {
            return status
        }
        return isNot(status)
    }
}

