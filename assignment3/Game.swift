
import Foundation

class Game {
    var id: String = ""
    
    var gameType: Bool = false
    var gameMode: Bool = true
    
    var startTime: String = ""
    var endTime: String = ""
    
    var completed: Bool = true
    var repetition: Int = 0
    
    //var buttonList: Array
    
    var totalClick: Int = 0
    var rightClick: Int = 0
    
    func toSummary() {
        
    }
}

//        games.getDocuments() { (result, err) in
//            // check for server error
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                // loop throgh the results
//                for document in result!.documents {
//                    print(document.get("repetition"))
//
//                }
//            }
//        }
        
//        var arrayOfMap = [[String: Int]]()
//        var map = ["jj":1]
//        arrayOfMap.append(map)
//
//
//        dump(arrayOfMap)
