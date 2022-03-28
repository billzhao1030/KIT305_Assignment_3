
import UIKit
import Firebase
import FirebaseFirestoreSwift

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var historyTable: UITableView!
    
    @IBOutlet var historyGamePrescribed: UIButton!
    @IBOutlet var historyGameDesigned: UIButton!
    
    @IBOutlet var historySearch: UIButton!
    @IBOutlet var historySeeAll: UIButton!
    
    
    @IBOutlet var searchBoxField: UITextField!
    var undoGame: Game?
    var undoID = ""
    var undoIndex = 1
    
    var id = ""
    var historyType = true
    
    var gameList: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTable.delegate = self
        historyTable.dataSource = self
        
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
                                    var right = 0
                                    var total = 0
                                    for click in game.buttonList! {
                                        let value = click.values
                                        total += 1
                                        if (value.contains(10) || value.contains(20) || value.contains(30) || value.contains(40) || value.contains(50)) == false {
                                            right += 1
                                        }
                                    }
                                    
                                    game.totalClick = total
                                    game.rightClick = right
                                    
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
            gameCell.historyComplete.text = "\(game.completed == true ? "" : "Not") completed"
        }
        
        return cell
    }
    
    
    @IBAction func shareAllHistory(_ sender: UIButton) {
        var shareText = ""
        for game in gameList {
            shareText += "\((game.toShare())) \n"
        }
        
        print(shareText)
    }
    
    @IBAction func SearchByTime(_ sender: Any) {
        let db = Firestore.firestore()
        let gamesCollection = db.collection(DATABASE)
        
        gamesCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let searchText: String = self.searchBoxField.text ?? ""
                if searchText.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    print("nothing")
                } else {
                    self.gameList.removeAll()
                    self.historyTable.reloadData()
                    for document in result!.documents {
                        let conversionResult = Result {
                            try document.data(as: Game.self)
                        }
                        
                        switch conversionResult {
                            case .success(let convertedDoc):
                                if var game = convertedDoc {
                                    game.id = document.documentID
                                    if game.gameType == self.historyType {
                                        if ((game.id?.contains(searchText.trimmingCharacters(in: .whitespacesAndNewlines))) == true) {
                                            var right = 0
                                            var total = 0
                                            for click in game.buttonList! {
                                                var value = click.values
                                                total += 1
                                                if (value.contains(10) || value.contains(20) || value.contains(30) || value.contains(40) || value.contains(50)) == false {
                                                    right += 1
                                                }
                                            }
                                            
                                            game.totalClick = total
                                            game.rightClick = right
                                            
                                            print("Game: \(game)")
                                            self.gameList.append(game)
                                        }
                                    }
                                } else {
                                    print("Document does not exist")
                                }
                            case .failure(let failure):
                                print("Error decoding movie: \(failure)")
                            }
                    }
                    
                    self.historyTable.reloadData()
                    
                    self.searchBoxField.text = ""
                }
            }
        }
    }
    
    @IBAction func SeeAll(_ sender: Any) {
        getGamesFromDB()
    }
 
    @IBAction func unwindToGameList(sender: UIStoryboardSegue) {
        print("\(undoGame)")
        print("\(undoIndex)")
        print("\(undoID)")
    
        gameList.remove(at: undoIndex)
        
        self.historyTable.reloadData()
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
