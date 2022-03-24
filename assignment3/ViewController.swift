//
//  ViewController.swift
//  assignment3
//
//  Created by lixue on 14/3/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

let DATABASE = "gamesIOS"

class ViewController: UIViewController {

    let defalutFile = UserDefaults.standard // name file
    
    var gameType: Bool = true // game type
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var summaryText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = defalutFile.string(forKey: "username")
        
        setSummaryText()
        
    }

    // set the username
    @IBAction func nameEntered(_ sender: Any) {
        let username = usernameTextField.text!
        print("User typed \(username)")
        
        defalutFile.set(username, forKey: "username")
    }
    
    @IBAction func modeSelectPrescribed(_ sender: Any) {
        gameType = true
    }
    
    @IBAction func modeSelectDesigned(_ sender: Any) {
        gameType = false
    }
    
    
    @IBAction func goToHistory(_ sender: Any) {
        print("history")
    }
    
    // set the total repetition round text
    func setSummaryText() {
        var summary = "Loading..."
        summaryText.text = summary
        
        var prescribedTotal = 0
        var designedTotal = 0
        
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        games.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Game.self)
                    }

                    switch conversionResult
                    {
                        case .success(let convertedDoc):
                            if let game = convertedDoc {
                                if game.gameType == true {
                                    prescribedTotal += game.repetition
                                    print("\(prescribedTotal)")
                                } else {
                                    designedTotal += game.repetition
                                }
                                
                                summary = "You have completed\n \(prescribedTotal) repetitions in Number in order\n \(designedTotal) repetitions in Matching Numbers"
                                
                                self.summaryText.text = summary
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding game: \(error)")
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToMenuPage(sender: UIStoryboardSegue) {
        
    }
}

