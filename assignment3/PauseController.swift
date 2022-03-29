//
//  PauseController.swift
//  assignment3
//
//  Created by lixue on 24/3/2022.
//

import UIKit

class PauseController: UIViewController {

    @IBOutlet var completeButton: UIButton!
    
    var completed = false
    var id = ""
    var isRound = true
    var isFree = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if completed == true {
            //completeButton.titleLabel?.text = "Finish Exercise"
            completeButton.setTitle("Finish Exercise", for: .normal)
        } else {
            //completeButton.titleLabel?.text = "Go back to Menu"
            completeButton.setTitle("Go back to Menu", for: .normal)
        }
        
        completeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 44)
    }
    
    func debugResult() {
        print("\(completed)")
        print("\(id)")
    }
    
    @IBAction func finshOrMenu(_ sender: Any) {
        if completed == true {
            
            
            performSegue(withIdentifier: "completeGameFromPause", sender: nil)
        } else {
            print("hey not finish")
            performSegue(withIdentifier: "unwindToMenuFromPause", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeGameFromPause" {
            if let finish = segue.destination as? GameFinishController {
                finish.id = self.id
                finish.isFree = self.isFree
                finish.isRound = self.isRound
                
            }
        }
    }
    

}
