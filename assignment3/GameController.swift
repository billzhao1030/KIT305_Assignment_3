
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
    
    var isRound = true
    var isFree = false
    
    var timeLeft = 0
    var timer : Timer? = Timer()
    
    var buttonList : [[String : Int]] = []
    
    var prescribedButtonSet = false
    
    @IBOutlet var gameProgress: UILabel!
    @IBOutlet var gameRule: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        debugResult()
        
        presetGame()
        if gameType == true {
            startPrescribedGame()
        } else {
            isFree = true
            isRound = false
            startDesignedGame()
        }
    }
            
    
    func startPrescribedGame(){
        createButtons()
        
        reposition()
        
        highlight()
    }
    
    
    func startDesignedGame() {
        completed = true
        createButtons()
    }
    
    func presetGame() {
        if gameType == true {
            buttonSize = buttonSize * 30 + 70
            
            gameRule.text = "Tap the button in number order (from 1)"
            
            if gameMode == true {
                isFree = false

                if round != -1 {
                    isRound = true
                    gameProgress.text = "1 of \(self.round) round"
                } else {
                    isRound = false
                    timeLeft = time
                    startCountDown()
                }
            } else {
                isFree = true
                isRound = false
                gameProgress.text = "Round 1"
            }
        } else {
            gameRule.text = "Long press and drag the number to pair them up"
            gameProgress.text = "Round 1"
        }
        
        initGameStore()
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
            "id": id,
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
        
        if gameType == true {
            for _ in 1...numOfButtons {
                var random = Int.random(in: 0...4)
                while numList.contains(random) {
                    random = Int.random(in: 0...4)
                }
                numList.append(random)
                randomX = random * 165
                xList.append(randomX)
            }
        } else {
            for _ in 1...(numOfButtons*2) {
                var random = Int.random(in: 0...5)
                while numList.contains(random) {
                    random = Int.random(in: 0...5)
                }
                numList.append(random)
                randomX = random * 125
                xList.append(randomX)
            }
        }
        
        return xList
    }
    
    func getPositionY() -> Array<Int>{
        var yList = [Int]()
        var randomY: Int = 0
        
        var numList = [Int]()
        
        if gameType == true {
            for _ in 1...numOfButtons {
                var random = Int.random(in: 0...4)
                while numList.contains(random) {
                    random = Int.random(in: 0...4)
                }
                numList.append(random)
                randomY = random * 165 + 250
                yList.append(randomY)
            }
        } else {
            for _ in 1...(numOfButtons*2) {
                var random = Int.random(in: 0...5)
                while numList.contains(random) {
                    random = Int.random(in: 0...5)
                }
                numList.append(random)
                randomY = random * 125 + 260
                yList.append(randomY)
            }
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
            
            let xPosition = getPositionX()
            let yPosition = getPositionY()
            
            for index in 1...numOfButtons {
                let button = self.view.viewWithTag(index) as? UIButton
                
                button?.frame = CGRect(x: xPosition[index-1], y: yPosition[index-1], width: buttonSize, height: buttonSize)
                
                button?.setTitle("\(index)", for: .normal)
                button?.setBackgroundImage(nil, for: .normal)
            }
        } else {
            for index in 1...(numOfButtons * 2) {
                let button = UIButton(type: .system)
                button.frame = CGRect(x: 200, y: 200, width: 120, height: 120)
                button.backgroundColor = .yellow
                button.layer.cornerRadius = 60
                button.setTitle("\(index)", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)

                button.tag = (index + 1) / 2 * 10 + 2 - index % 2
                print("id: \(button.tag)")

                self.view.addSubview(button)
            }
            
            let xPosition = getPositionX()
            let yPosition = getPositionY()
            
            for index in 1...(numOfButtons * 2) {
                let button = self.view.viewWithTag((index + 1) / 2 * 10 + 2 - index % 2) as? UIButton
                
                button?.frame = CGRect(x: xPosition[index-1], y: yPosition[index-1], width: 120, height: 120)
                
                button?.setTitle("\((index+1)/2)", for: .normal)
                button?.setBackgroundImage(nil, for: .normal)
            }
        }
    }
    
    func reposition() {
        let xPosition = getPositionX()
        let yPosition = getPositionY()
        
        for index in 1...numOfButtons {
            let button = self.view.viewWithTag(index) as? UIButton
            
            if isRandom == true {
                button?.frame = CGRect(x: xPosition[index-1], y: yPosition[index-1], width: buttonSize, height: buttonSize)
            }
            
            button?.setTitle("\(index)", for: .normal)
            button?.setBackgroundImage(nil, for: .normal)
        }
    }
    
    func startCountDown() {
        gameProgress.text = "\(timeLeft)s  Round \(self.completeRound + 1)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        timeLeft -= 1
        
        if timeLeft >= 0 {
            gameProgress.text = "\(timeLeft)s  Round \(self.completeRound + 1)"
        } else {
            timer?.invalidate()
            timer = nil
            completeGame()
        }
    }
    
    @objc func prescribedButtonAction(sender: UIButton!) {
        print("id:\(sender.tag)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeClick = dateFormatter.string(from: Date())
        
        if sender.tag == btnNow {
            sender.setBackgroundImage(UIImage.checkmark, for: .normal)
            sender.setTitle("", for: .normal)
            
            buttonList.append([timeClick : btnNow])
            uploadButtonList()
            
            btnNow += 1
            
            if btnNow > numOfButtons {
                btnNow = 1
                completeRound += 1
                
                if gameMode ==  false {
                    completed = true
                }
            
                uploadRound()
                
                if gameMode == true {
                    if self.round != -1 {
                        if completeRound == self.round {
                            completeGame()
                        } else {
                            reposition()
                            gameProgress.text = "\(completeRound + 1) of \(self.round) round"
                        }
                    } else {
                        reposition()
                        gameProgress.text = "\(timeLeft)s  Round \(self.completeRound + 1)"
                    }
                } else {
                    gameProgress.text = "Round \(completeRound)"
                    reposition()
                }
            }
            highlight()
        } else {
            buttonList.append([timeClick : sender.tag * 10])
            uploadButtonList()
        }
    }
    
    func uploadRound() {
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        
        games.document(id).updateData([
            "repetition": completeRound,
            "endTime": currentTime
        ]) { (err) in
            if let err = err {
                print("Error updating repetition: \(err)")
            } else {
                print("Document updated 2!")
            }
        }
    }
    
    func uploadButtonList() {
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        
        games.document(id).updateData([
            "buttonList": buttonList,
            "endTime": currentTime
        ]) { (err) in
            if let err = err {
                print("Error updating repetition: \(err)")
            } else {
                print("Document updated 1!")
            }
        }
    }
    
    func completeGame() {
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        print("complete hey")
        
        completed = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        
        games.document(id).updateData([
            "buttonList": buttonList,
            "endTime": currentTime,
            "completed": completed
        ]) { (err) in
            if let err = err {
                print("Error updating repetition: \(err)")
            } else {
                print("Document updated! hh")
            }
        }
        
        performSegue(withIdentifier: "gameFinishSegue", sender: nil)
    }
    
    func highlight() {
        if hasIndication == true {
            let button = self.view.viewWithTag(btnNow) as? UIButton
            
            button?.backgroundColor = .orange
            if button?.tag != 1 {
                let prevButton = self.view.viewWithTag(btnNow - 1) as? UIButton
                prevButton?.backgroundColor = .yellow
            } else {
                let prevButton = self.view.viewWithTag(self.numOfButtons) as? UIButton
                prevButton?.backgroundColor = .yellow
            }
        }
    }
    
    func goToMenu() {
        performSegue(withIdentifier: "goToMenuFromGame", sender: nil)
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        
        uploadButtonList()
    }
    
    @IBAction func unwindToGamePage(sender: UIStoryboardSegue) {
        if gameType == true {
            if gameMode == true {
                if self.time != -1 {
                    startCountDown()
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pauseSegue" {
            if let pause = segue.destination as? PauseController {
                pause.completed = self.completed
                pause.id = self.id
            }
        } else if segue.identifier == "gameFinishSegue" {
            if let finish = segue.destination as? GameFinishController {
                finish.id = self.id
                finish.gameType = self.gameType
                finish.isRound = self.isRound
            }
        }
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
