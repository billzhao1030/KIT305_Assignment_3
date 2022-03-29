
import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseUI

class HistoryDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var rightClick: UILabel!
    @IBOutlet var totalClick: UILabel!
    
    @IBOutlet var buttonListTitle: UILabel!
    @IBOutlet var buttonListTable: UITableView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var nonComplete: UILabel!
    var game : Game?
    var gameIndex : Int?
    var gameID = ""
    var gameUndo = Game()
    
    var buttonList : [[String:Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonListTable.delegate = self
        buttonListTable.dataSource = self
        
        if game?.gameType == true {
            showElements(false)
            calculateClick()
        } else {
            showElements(true)
        }
        
        
        if game?.completed == false {
            nonComplete.isHidden = false
        }
        
        
        if game?.completed == true {
            showImage()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonClickCell", for: indexPath)
        
        let buttonClick = buttonList[indexPath.row]

        if let clickCell = cell as? ButtonClickCell {
            
            let time = buttonClick.keys
            let value = buttonClick.values
            
            
            if (value.contains(10) || value.contains(20) || value.contains(30) || value.contains(40) || value.contains(50)) == true {
                clickCell.buttonClick.textColor = UIColor.red
            } else {
                clickCell.buttonClick.textColor = UIColor.black
            }
            
            let timeStr = "\(time)"[2..<10]
            let clickStr = "\(value)"[1..<2]
            
            clickCell.buttonClick.text = "\(timeStr) : \(clickStr)"
        }
        
        return cell
    }
    
    func calculateClick() {
        buttonList = game?.buttonList ?? []
    
        let right: Int = (game?.rightClick)!
        let total: Int = (game?.totalClick)!
        rightClick.text = "The right click : \(right)"
        totalClick.text = "The total click : \(total)"
        
        self.buttonListTable.reloadData()
    }
    
    func showElements(_ isShow: Bool) {
        rightClick.isHidden = isShow
        totalClick.isHidden = isShow
        buttonListTitle.isHidden = isShow
    }
    
    
    func showImage() {
        let storageRef = Storage.storage().reference()
        
        let exercise = (game?.id)!
        print("imageIOS/\(exercise).jpg")
        
        let ref = storageRef.child("imageIOS/\(exercise).jpg")
        
        imageView.sd_setImage(with: ref)
    }
    
    
    @IBAction func shareThis(_ sender: UIButton) {
        let shareText = "\((game?.toShare())!)"
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: [])

        activityVC.popoverPresentationController?.sourceView = sender
        activityVC.popoverPresentationController?.sourceRect = sender.frame
        
        present(activityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteThis(_ sender: Any) {
        // create an alert view
        let alert = UIAlertController(
            title: "Caution!",
            message: "Confirm to delete this exercise?",
            preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertAction.Style.default,
            handler:  {(action:UIAlertAction!)in
                let db = Firestore.firestore()
                let games = db.collection(DATABASE)
                
                let idDelete = self.game?.id
                
                print("\(self.game?.id)")
                
                games.document(idDelete!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                self.gameID = idDelete ?? ""
                
                self.performSegue(withIdentifier: "deleteSegue", sender: nil)
            }))
        
        alert.addAction(UIAlertAction(
            title: "No",
            style: UIAlertAction.Style.default,
            handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "deleteSegue" {
            if let gameHistory = segue.destination as? HistoryController {
                gameHistory.undoID = game?.id ?? ""
                gameHistory.undoIndex = gameIndex ?? 0
                
                gameHistory.undoGame = game
            }
        }
    }
}

extension String {
    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex...endIndex])
    }
    
    subscript(_ indexs: Range<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex..<endIndex])
    }
}


