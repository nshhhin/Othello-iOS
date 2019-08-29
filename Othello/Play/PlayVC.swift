
import UIKit

class PlayVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var arrayPanels: [[PanelStatus]] = []
    var turnStatus: TurnStatus = .black
    let fieldWidth = 8
    let margin = 1.0
    
    
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
        print("===============")
        
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
            arrayPanels[Int(indexPath.row/fieldWidth)][indexPath.row%fieldWidth] = .black
            turnStatus = .white
        case .white:
            arrayPanels[Int(indexPath.row/fieldWidth)][indexPath.row%fieldWidth] = .white
            turnStatus = .black
        }
        
        filedCollectionV.reloadData()
    }
    
}

