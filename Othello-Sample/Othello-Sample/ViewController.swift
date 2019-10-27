
import UIKit

class ViewController: UIViewController {

    let FIELD_SIZE = CGSize(width: 8, height: 8)

    var turn: FieldStatus = .black

    var fieldStates: [[FieldStatus]] = [
        [.none, .none, .none, .none,  .none,  .none, .none, .none],
        [.none, .none, .none, .none,  .none,  .none, .none, .none],
        [.none, .none, .none, .none,  .none,  .none, .none, .none],
        [.none, .none, .none, .black, .white, .none, .none, .none],
        [.none, .none, .none, .white, .black, .none, .none, .none],
        [.none, .none, .none, .none,  .none,  .none, .none, .none],
        [.none, .none, .none, .none,  .none,  .none, .none, .none],
        [.none, .none, .none, .none,  .none,  .none, .none, .none],
    ]

    var emptyField: [[FieldStatus]] = [
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
       [.none, .none, .none, .none,  .none,  .none, .none, .none],
   ]

    @IBOutlet weak var turnSegmentV:
        UISegmentedControl!

    @IBOutlet weak var fieldCollectionV: UICollectionView! {
        didSet {
            fieldCollectionV.delegate   = self
            fieldCollectionV.dataSource = self
            fieldCollectionV.register(
            UINib(nibName: "FieldCell", bundle: nil),
            forCellWithReuseIdentifier: "FieldCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareField()
        reloadField()
    }

    func reloadField(){
        fieldCollectionV.reloadData()
    }

    func refreshEmptyField(){
        emptyField = [
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
            [.none, .none, .none, .none,  .none,  .none, .none, .none],
        ]
    }

    func prepareField(){
        // 縦横を計算してあげる
        let width: CGFloat = fieldCollectionV.layer.bounds.width / FIELD_SIZE.width
        let height = width

        // レイアウトを設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        fieldCollectionV.setCollectionViewLayout(layout, animated: false)
    }

    // 置けるかどうかの判定
    func isPuttable(x: Int, y: Int) -> Bool {

        refreshEmptyField()

        var revSumCount = 0
        for dx in -1...1 {
            for dy in -1...1 {
                if dx == 0 && dy == 0 {
                    continue
                }
                if !isInsideRange(x: x+dx, y: y+dy) {
                    continue
                }
                let revCount = getReverseCount(x: x, y: y, dx: dx, dy: dy, count: 0)
                for i in 0..<revCount+1 {
                   emptyField[x+i*dx][y+i*dy] = turn
                }
                revSumCount += revCount
            }
        }

        for x in 0..<Int(FIELD_SIZE.width) {
            for y in 0..<Int(FIELD_SIZE.height) {
                if emptyField[x][y] == turn {
                    fieldStates[x][y] = turn
                }
            }
        }

        if revSumCount > 0 {
            return true
        }
        return false

    }

    // x,yの盤についていくつ返せるかを返す
    func getReverseCount(x: Int, y: Int, dx: Int, dy: Int, count: Int) -> Int {
        if fieldStates[x+dx][y+dy] == .none {
            return 0
        }
        else if fieldStates[x+dx][y+dy] == turn {
            return count
        }
        else {
            return getReverseCount(x: x+dx, y: y+dy, dx: dx, dy: dy, count: count+1)
        }
        return count
    }

    func notTurn(_ turn: FieldStatus) -> FieldStatus {
        switch turn {
        case .black:
            return .white
        case .black:
            return .black
        default:
            return .none
        }
    }

    func isInsideRange(x: Int, y: Int) -> Bool {
        let flag = (x > 0) && (x < Int(FIELD_SIZE.width)) && (y > 0) && (y < Int(FIELD_SIZE.height))
        return flag
    }

}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let x = Int( indexPath.row % Int(FIELD_SIZE.width ))
        let y = Int( indexPath.row / Int(FIELD_SIZE.width ))

//        print( getReverseCount(x: x, y: y, dx: dx, dy: dy, count: 0) )

        if fieldStates[x][y] != .none {
            return
        }

        if !isPuttable(x: x, y: y) {
            // 何もしない
            return
        }

        switch turn {
        case .black:
            fieldStates[x][y] = .black
            turn = .white
            turnSegmentV.selectedSegmentIndex = 1
        case .white:
            fieldStates[x][y] = .white
            turn = .black
            turnSegmentV.selectedSegmentIndex = 0
        default:
            break
        }
        reloadField()

    }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(FIELD_SIZE.width * FIELD_SIZE.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let x = Int( indexPath.row % Int(FIELD_SIZE.width ))
        let y = Int( indexPath.row / Int(FIELD_SIZE.width ))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FieldCell", for: indexPath) as! FieldCell
        cell.setStatus(fieldStates[x][y])
        cell.banV.layer.cornerRadius = fieldCollectionV.layer.bounds.width / ( 2.0 * FIELD_SIZE.width )
        cell.update()
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width: CGFloat = collectionView.layer.bounds.width / FIELD_SIZE.width
        let height = width
        return CGSize(width: width, height: height)
    }
}
