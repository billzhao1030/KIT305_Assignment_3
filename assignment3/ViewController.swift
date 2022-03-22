//
//  ViewController.swift
//  assignment3
//
//  Created by lixue on 14/3/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ViewController: UIViewController {

    let defalutFile = UserDefaults.standard // name file
    
    @IBOutlet var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = defalutFile.string(forKey: "username")
        
        //let db = Firestore.firestore()
        //let games = db.collection("games")
    }

    // set the username
    @IBAction func nameEntered(_ sender: Any) {
        let username = usernameTextField.text!
        print("User typed \(username)")
        
        defalutFile.set(username, forKey: "username")
    }
    
    @IBAction func modeSelectPrescribed(_ sender: Any) {
        print("game 1")
    }
    
    @IBAction func modeSelectDesigned(_ sender: Any) {
        print("game 2")
    }
    
    
    @IBAction func goToHistory(_ sender: Any) {
        print("history")
    }
    
    @IBAction func unwindToMenuPage(sender: UIStoryboardSegue) {
        
    }
}

