//
//  GameFinishController.swift
//  assignment3
//
//  Created by lixue on 24/3/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class GameFinishController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var takePicture: UIButton!
    @IBOutlet var selectPicture: UIButton!
    @IBOutlet var summaryText: UITextView!
    
    @IBOutlet var imageView: UIImageView!
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
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                print("Camera available")
                let imagePicker:UIImagePickerController = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                print("No camera available")
            }
            hasPicture = true
            takePicture.titleLabel?.text = "Go to Menu"
        } else {
            performSegue(withIdentifier: "unwindToMenuFromFinish", sender: nil)
        }
    }
    @IBAction func startGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Gallery available")
            
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        {
            imageView.image = image
            hasPicture = true
            takePicture.titleLabel?.text = "Go to Menu"
            
            let storage = Storage.storage().reference()
            
            storage.child("imageIOS/\(id).jpg")
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setGameSummary() {
        summaryText.text = thisGame.toSummary(isRound, isFree)
    }
    
    func getGame() {
        let db = Firestore.firestore()
        let gamesCollection = db.collection(DATABASE)
        
        let doc = gamesCollection.document(id)
        
//        doc.getDocument(as: Game.self) { result in
//            switch result {
//                case .success(let city):
//                    // A `City` value was successfully initialized from the DocumentSnapshot.
//                    print("City: \(city)")
//                case .failure(let error):
//                    // A `City` value could not be initialized from the DocumentSnapshot.
//                    print("Error decoding city: \(error)")
//                }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
