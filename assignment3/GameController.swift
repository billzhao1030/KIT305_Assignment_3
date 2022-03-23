
import UIKit
import Firebase
import FirebaseFirestoreSwift

class GameController: UIViewController {
    var id = ""
    
    var gameType = true
    var gameMode = true
    var round = -1
    var time = -1
    var numOfButtons = 3
    var isRandom = true
    var hasIndication = true
    var buttonSize = 2
    
    var completed = false
    var btnNow = 1
    var completeRound = 0
    
    var timeLeft = 0
    
    var buttonList = 1
    
    @IBOutlet var gameProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        debugResult()
        
        
        if gameType == true {
            presetPrescribed()
            startPrescribedGame()
        } else {
            startDesignedGame()
        }
    }
            
    
    func startPrescribedGame(){
        createButtons()
        
        reposition()
    }
    
    
    func startDesignedGame() {
        initGameStore()
    }
    
    func presetPrescribed() {
        print("Before: \(buttonSize)")
        buttonSize = buttonSize * 30 + 70
        print("After: \(buttonSize)")

        initGameStore()
        
        if gameMode == true {
            if round == -1 {
                gameProgress.text = "1 of \(round) round"
            } else {
                
            }
        } else {
            gameProgress.text = "Round 1"
        }
    }
    
    func initGameStore() {
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        id = dateFormatter.string(from: Date())
        
        games.document(id).setData([
            "completed": completed,
            "startTime": currentTime,
            "endTime": currentTime,
            "gameMode": gameMode,
            "gameType": gameType,
            "repetition": completeRound,
            "buttonList": buttonList
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document succesfully written!")
            }
        }
    }
    
    func getPositionX() -> Array<Int>{
        var xList = [Int]()
        var randomX: Int = 0
        
        var numList = [Int]()
        
        for i in 1...numOfButtons {
            var random = Int.random(in: 0...4)
            while numList.contains(random) {
                random = Int.random(in: 0...4)
            }
            numList.append(random)
            randomX = random * 165
            xList.append(randomX)
        }
        
        return xList
    }
    
    func getPositionY() -> Array<Int>{
        var yList = [Int]()
        var randomY: Int = 0
        
        var numList = [Int]()
        
        for i in 1...numOfButtons {
            var random = Int.random(in: 0...4)
            while numList.contains(random) {
                random = Int.random(in: 0...4)
            }
            numList.append(random)
            randomY = random * 165 + 180
            yList.append(randomY)
        }
        return yList
    }
    
    func createButtons() {
        if gameType == true {
            for index in 1...numOfButtons {
                let button = UIButton(type: .system)
                button.frame = CGRect(x: 200, y: 200, width: buttonSize, height: buttonSize)
                button.backgroundColor = .yellow
                button.layer.cornerRadius = CGFloat(buttonSize / 2)
                button.setTitle("\(index)", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
                button.addTarget(self, action: #selector(prescribedButtonAction), for: .touchUpInside)
                button.tag = index
                print("id: \(button.tag)")

                self.view.addSubview(button)
            }
        } else {
            
        }
    }
    
    func reposition() {
        let xPosition = getPositionX()
        let yPosition = getPositionY()
        
        for index in 1...numOfButtons {
            let button = self.view.viewWithTag(index) as? UIButton
            
            if isRandom == true {
                button?.frame = CGRect(x: xPosition[index-1], y: yPosition[index-1], width: buttonSize, height: buttonSize)
                
                print("x: \(xPosition[index-1])")
                print("y: \(yPosition[index-1])")
            }
            
            button?.setTitle("\(index)", for: .normal)
        }
    }
    
    @objc func prescribedButtonAction(sender: UIButton!) {
        print("id:\(sender.tag)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.string(from: Date())
        
        if sender.tag == btnNow {
            btnNow += 1
            
            
            uploadButtonList()
        } else {
            
            
            uploadButtonList()
        }
        
        if btnNow > numOfButtons {
            btnNow = 1
            completeRound += 1
            
            reposition()
        }
    }
    
    func uploadRound() {
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        games.document(id).updateData([
            "repetition": completeRound
        ]) { (err) in
            if let err = err {
                print("Error updating repetition: \(err)")
            } else {
                print("Document updated!")
            }
        }
    }
    
    func uploadButtonList() {
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        games.document(id).updateData([
            "buttonList": buttonList
        ]) { (err) in
            if let err = err {
                print("Error updating repetition: \(err)")
            } else {
                print("Document updated!")
            }
        }
    }
    
    func completeGame() {
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        
    }
    
    func highlight() {
        
    }
    
    func goToMenu() {
        
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        
    }
    
    @IBAction func unwindToGamePage(sender: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func debugResult() {
        print("===============game")
        print("game type: \(gameType)")
        print("game Mode: \(gameMode)")
        print("time: \(time)")
        print("round: \(round)")
        print("num btn: \(numOfButtons)")
        print("random: \(isRandom)")
        print("indication: \(hasIndication)")
    }
}
