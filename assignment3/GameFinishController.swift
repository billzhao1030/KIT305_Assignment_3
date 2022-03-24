//
//  GameFinishController.swift
//  assignment3
//
//  Created by lixue on 24/3/2022.
//

import UIKit

class GameFinishController: UIViewController {

    @IBOutlet var takePicture: UIButton!
    @IBOutlet var selectPicture: UIButton!
    @IBOutlet var summaryText: UITextView!
    
    var id = ""
    var hasPicture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func startCamera(_ sender: Any) {
        if hasPicture == false {
            
        } else {
            performSegue(withIdentifier: "unwindToMenuFromFinish", sender: nil)
        }
    }
    @IBAction func startGallery(_ sender: Any) {
        
    }
    
    func setGameSummary() {
        var summary = ""
        
        summaryText.text = summary
    }
}
