
import UIKit

class DesignedCustomize: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var buttonNumPicker: UIPickerView!
    @IBOutlet var isRandomSwitch: UISwitch!
    
    var buttonNumPickerData: [String] = [String]()
    let buttonNumList = ["1", "2", "3"]
    
    var numOfButtons = 2
    var isRandom = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buttonNumPicker.delegate = self
        self.buttonNumPicker.dataSource = self
        
        debugResult()
        
        buttonNumPickerData = buttonNumList
        
        buttonNumPicker.selectRow(1, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buttonNumPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return buttonNumPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numOfButtons = row + 1
        debugResult()
    }
    
    @IBAction func setRandom(_ sender: Any) {
        isRandom = isRandomSwitch.isOn
        debugResult()
    }
    
    
    func debugResult() {
        print("isRandom: \(isRandom)")
        print("num: \(numOfButtons)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameFromDesigned" {
            if let game = segue.destination as? GameController {
                game.gameType = false
                game.isRandom = self.isRandom
                game.numOfButtons = self.numOfButtons
            }
        }
    }
}
