
import UIKit
import Firebase
import FirebaseFirestoreSwift

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var historyTable: UITableView!
    
    @IBOutlet var historyGamePrescribed: UIButton!
    @IBOutlet var historyGameDesigned: UIButton!
    
    @IBOutlet var historySearch: UIButton!
    @IBOutlet var historySeeAll: UIButton!
    
    @IBOutlet var undoText: UILabel!
    @IBOutlet var undoYes: UIButton!
    @IBOutlet var undoNo: UIButton!
    
    var id = ""
    var historyType = true
    
    var gameList: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTable.delegate = self
        historyTable.dataSource = self
        
        hideUndo(true)
        
        historyGamePrescribed.tintColor = UIColor.blue
        historyGameDesigned.tintColor = UIColor.gray
        getGamesFromDB()
    }
    
    
    @IBAction func seeHistoryPrescribed(_ sender: Any) {
        if historyType == false {
            historyType = true
            getGamesFromDB()
            historyGamePrescribed.tintColor = UIColor.blue
            historyGameDesigned.tintColor = UIColor.gray
        }
    }
    
    @IBAction func seeHistoryDesigned(_ sender: Any) {
        if historyType == true {
            historyType = false
            getGamesFromDB()
            historyGamePrescribed.tintColor = UIColor.gray
            historyGameDesigned.tintColor = UIColor.blue
        }
    }
    
    func getGamesFromDB() {
        let db = Firestore.firestore()
        let gamesCollection = db.collection(DATABASE)
        
        gamesCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.gameList.removeAll()
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Game.self)
                    }
                    
                    switch conversionResult {
                        case .success(let convertedDoc):
                            if var game = convertedDoc {
                                game.id = document.documentID
                                if game.gameType == self.historyType {
                                    print("Game: \(game)")
                                    self.gameList.append(game)
                                }
                            } else {
                                print("Document does not exist")
                            }
                        case .failure(let failure):
                            print("Error decoding movie: \(failure)")
                        }
                }
                
                self.historyTable.reloadData()
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath)
        
        let game = gameList[indexPath.row]
        
        if let gameCell = cell as? HistoryTableCell {
            var modeText = ""
            
            if game.gameType == true {
                modeText = (game.gameMode == true) ? "Goal Mode" : "Free-play"
            } else {
                modeText = "Free-play"
            }
            
            gameCell.historyTitle.text = "\(indexPath.row + 1). \(modeText)"
            gameCell.historyStart.text = "Start: \(game.startTime)"
            gameCell.historyEnd.text = "End: \(game.endTime)"
            gameCell.historyRepetition.text = "Repetition: \(game.repetition)"
            gameCell.historyComplete.text = "\(game.completed == true ? "Not" : "") completed"
        }
        
        return cell
    }
    
    
    @IBAction func shareAllHistory(_ sender: UIButton) {
        print("share")
        let text = "This is the text....."
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func hideUndo(_ isHide: Bool) {
        undoText.isHidden = isHide
        undoYes.isHidden = isHide
        undoNo.isHidden = isHide
    }
    
    @IBAction func unwindToGameList(sender: UIStoryboardSegue) {
    }

    @IBAction func unwindToGameListWithCancel(sender: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showGameDetails" {
            guard let detailViewController = segue.destination as? HistoryDetailController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedGameCell = sender as? HistoryTableCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = historyTable.indexPath(for: selectedGameCell) else {
                fatalError("The selected cell is not being desplayed by the table")
            }
            
            let selectedGame = gameList[indexPath.row]
            
            detailViewController.game = selectedGame
            detailViewController.gameIndex = indexPath.row
        }
    }
}
