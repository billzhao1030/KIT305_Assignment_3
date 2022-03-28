//
//  GameFinishController.swift
//  assignment3
//
//  Created by lixue on 24/3/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class GameFinishController: UIViewController {

    @IBOutlet var takePicture: UIButton!
    @IBOutlet var selectPicture: UIButton!
    @IBOutlet var summaryText: UITextView!
    
    var id = ""
    var hasPicture = false
    var isRound = true
    var isFree = false
    var gameType = true
    
    var thisGame = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getGame()
        
        setGameSummary()
    }
    

    @IBAction func startCamera(_ sender: Any) {
        if hasPicture == false {
            
            hasPicture = true
        } else {
            performSegue(withIdentifier: "unwindToMenuFromFinish", sender: nil)
        }
    }
    @IBAction func startGallery(_ sender: Any) {
        
    }
    
    func setGameSummary() {
        summaryText.text = thisGame.toSummary(isRound, isFree)
    }
    
    func getGame() {
        let db = Firestore.firestore()
        let gamesCollection = db.collection(DATABASE)
        
//        gamesCollection.document(id).getDocument(as: Game.self) { result,err  in
//            switch result {
//                case .success(let game) :
//                        thisGame = game
//
//                case .failure(let error) :
//                        printContent("Error decoding: \(error)")
//            }
         
//        }
    }
}
