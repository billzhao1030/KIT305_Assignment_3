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
        
        //let db = Firestore.firestore()
        //let games = db.collection("games")
        
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
        var prescribedTotal = 0
        var designedTotal = 0
        
        let db = Firestore.firestore()
        let games = db.collection(DATABASE)
        
        
        summaryText.text = summary
    }
    
    @IBAction func unwindToMenuPage(sender: UIStoryboardSegue) {
        
    }
}

