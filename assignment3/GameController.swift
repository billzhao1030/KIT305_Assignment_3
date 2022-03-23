
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
    
    var btnNow = 1
    var completeRound = 0
    
    var timeLeft = 0
    
    var buttonList = 1
    

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
    
    @objc func prescribedButton(sender: UIButton!) {
        print("id:\(sender.tag)")
        
        if sender.tag == btnNow {
            btnNow += 1
        } else {
            
        }
        
        if btnNow > numOfButtons {
            btnNow = 1
            completeRound += 1
            
            reposition()
        }
    }
        
    
    func startPrescribedGame(){
        createButtons()
        
        reposition()
    }
    
    
    func startDesignedGame() {
        
    }
    
    func presetPrescribed() {
        print("Before: \(buttonSize)")
        buttonSize = buttonSize * 30 + 70
        print("After: \(buttonSize)")

        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        
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
        for index in 1...numOfButtons {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 200, y: 200, width: buttonSize, height: buttonSize)
            button.backgroundColor = .yellow
            button.layer.cornerRadius = CGFloat(buttonSize / 2)
            button.setTitle("\(index)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
            button.addTarget(self, action: #selector(prescribedButton), for: .touchUpInside)
            button.tag = index
            print("id: \(button.tag)")

            self.view.addSubview(button)
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
    
    func uploadRound() {
        
    }
    
    func uploadButtonList() {
        
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
