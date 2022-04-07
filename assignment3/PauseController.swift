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
        
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 44)
        
        if completed == true {
            completeButton.configuration?.attributedTitle = AttributedString("Finish Exercise", attributes: container)
        } else {
            completeButton.configuration?.attributedTitle = AttributedString("Go back to Menu", attributes: container)
        }
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
