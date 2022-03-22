
import UIKit

class GameController: UIViewController {
    
    var gameType = true
    var gameMode = true
    var round = -1
    var time = -1
    var numOfButtons = 3
    var isRandom = true
    var hasIndication = true
    var buttonSize = 2
    

    override func viewDidLoad() {
        super.viewDidLoad()

        debugResult()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
          button.backgroundColor = .green
          button.setTitle("Test Button", for: .normal)
          button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

          self.view.addSubview(button)
        
        if gameType == true {
            startPrescribedGame()
        } else {
            startDesignedGame()
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }
        
    
    func startPrescribedGame(){
        
    }
    
    
    func startDesignedGame() {
        
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
