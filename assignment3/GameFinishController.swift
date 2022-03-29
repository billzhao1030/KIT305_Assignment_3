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
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getGame()
    }
    

    @IBAction func startCamera(_ sender: Any) {
        if hasPicture == false {
            startCamera()
            hasPicture = true
            takePicture.titleLabel?.text = "Go to Menu"
        } else {
            performSegue(withIdentifier: "unwindToMenuFromFinish", sender: nil)
        }
    }
    @IBAction func startGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func startCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true)
        } else {
            print("No camera")
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        hasPicture = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        guard let imageData = info[.imageURL] as? URL else {
            return
        }
        
        imageView.image = image
        hasPicture = true
        takePicture.titleLabel?.text = "Go to Menu"
        
        uploadImage(fileURL: imageData)
    }
    
    func uploadImage(fileURL: URL) {
        let ref = storage.child("imageIOS/\(id).jpg")
        
        let local = fileURL
        
        let uploadTask = ref.putFile(from: local, metadata: nil) { (metadata, err) in
            guard let metadata = metadata else {
                print(err?.localizedDescription)
                return
            }
            print("Uploaded")
        }
    }
    
    func setGameSummary() {
        print(isRound)
        print(isFree)
        
        summaryText.text = thisGame.toSummary(isRound, isFree)
    }
    
    func getGame() {
        let db = Firestore.firestore()
        let gamesCollection = db.collection(DATABASE)
        
        let doc = gamesCollection.document(id)
        
        doc.getDocument() { (result, err) in
            if let err = err {
                print("Error getting document")
            } else {
                let conversionResult = Result {
                    try result?.data(as: Game.self)
                }
                
                switch conversionResult {
                case .success(let success):
                    if var game = success {
                        print("Gamehhh: \(game)")
                        self.thisGame = game
                        
                        self.setGameSummary()
                    } else {
                        print("Document does not exist")
                    }
                case .failure(let failure):
                    print("Error decoding game")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
