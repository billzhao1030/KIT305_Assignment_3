
import UIKit

class PrescribedCustomize: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var goalModeBtn: UIButton!
    @IBOutlet var freeModeBtn: UIButton!
    @IBOutlet var roundBtn: UIButton!
    @IBOutlet var timeBtn: UIButton!
    
    @IBOutlet var goalPicker: UIPickerView!
    @IBOutlet var buttonNumPicker: UIPickerView!
    
    @IBOutlet var isRandomSwitch: UISwitch!
    @IBOutlet var hasIndicationSwitch: UISwitch!
    
    @IBOutlet var buttonSizeSlider: UISlider!
    
    var goalPickerData: [String] = [String]()
    var buttonNumPickerData: [String] = [String]()
    
    let roundList = ["3", "4", "5", "6", "7", "8"]
    let timeList = ["0.5 minute(s)", "1 minute(s)", "1.5 minute(s)", "2 minute(s)", "2.5 minute(s)"]
    let buttonNumList = ["2", "3", "4", "5"]
    
    var gameType = true
    var gameMode = true
    var goalType = true
    var round = 5
    var time = -1
    
    var numOfButtons = 3
    var buttonSize = 2
    var isRandom = true
    var hasIndication = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalModeBtn.tintColor = UIColor.blue
        freeModeBtn.tintColor = UIColor.gray
        roundBtn.tintColor = UIColor.blue
        timeBtn.tintColor = UIColor.gray

        // connect data
        self.goalPicker.delegate = self
        self.goalPicker.dataSource = self
        self.buttonNumPicker.delegate = self
        self.buttonNumPicker.dataSource = self
        
        goalPickerData = roundList
        buttonNumPickerData = buttonNumList
        
        goalPicker.selectRow(2, inComponent: 0, animated: false)
        buttonNumPicker.selectRow(1, inComponent: 0, animated: false)
        
        debugResult()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == goalPicker {
            return goalPickerData.count
        } else {
            return buttonNumPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == goalPicker {
            return goalPickerData[row]
        } else {
            return buttonNumPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == goalPicker {
            if goalType == true {
                round = row + 3
                time = -1
            } else {
                round = -1
                time = (row + 1) * 30
            }
        } else {
            numOfButtons = row + 2
        }
        debugResult()
    }
    
    // set goal mode
    @IBAction func chooseGoalMode(_ sender: Any) {
        gameMode = true

        timeBtn.isEnabled = true
        roundBtn.isEnabled = true
        
        goalPicker.isUserInteractionEnabled = true
        
        goalModeBtn.tintColor = UIColor.blue
        freeModeBtn.tintColor = UIColor.gray
        
        debugResult()
    }
    
    @IBAction func chooseFreeMode(_ sender: Any) {
        gameMode = false
        
        timeBtn.isEnabled = false
        roundBtn.isEnabled = false
        
        goalPicker.isUserInteractionEnabled = false
        
        goalModeBtn.tintColor = UIColor.gray
        freeModeBtn.tintColor = UIColor.blue
        
        debugResult()
    }
    
    //set switch
    @IBAction func setIsRandom(_ sender: Any) {
        isRandom = isRandomSwitch.isOn
    }
    
    
    @IBAction func setHasIndication(_ sender: Any) {
        hasIndication = hasIndicationSwitch.isOn
    }
    
    @IBAction func setRound(_ sender: Any) {
        goalPickerData = roundList
        goalType = true
        goalPicker.reloadAllComponents()
        
        goalPicker.selectRow(2, inComponent: 0, animated: false)
        
        round = 5
        time = -1
        
        roundBtn.tintColor = UIColor.blue
        timeBtn.tintColor = UIColor.gray
        
        debugResult()
    }
    
    @IBAction func setTime(_ sender: Any) {
        goalPickerData = timeList
        goalType = false
        goalPicker.reloadAllComponents()
        
        goalPicker.selectRow(2, inComponent: 0, animated: false)
        
        round = -1
        time = 90
        
        roundBtn.tintColor = UIColor.gray
        timeBtn.tintColor = UIColor.blue
        
        debugResult()
    }
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
        buttonSize = Int(buttonSizeSlider.value)
        
        debugResult()
    }
    
    func debugResult() {
        print("===============")
        print("game type: \(gameType)")
        print("game Mode: \(gameMode)")
        print("time: \(time)")
        print("round: \(round)")
        print("num btn: \(numOfButtons)")
        print("random: \(isRandom)")
        print("indication: \(hasIndication)")
        print("button size: \(buttonSize)")
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameFromPrescribed" {
            if let game = segue.destination as? GameController {
                game.gameType = self.gameType
                game.gameMode = self.gameMode
                game.round = self.round
                game.time = self.time
                game.numOfButtons = self.numOfButtons
                game.isRandom = self.isRandom
                game.hasIndication = self.hasIndication
                game.buttonSize = self.buttonSize
            }
        }
    }
    

}
