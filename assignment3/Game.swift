
import Foundation

public struct Game : Codable {
    var id: String?
    
    var gameType: Bool = false
    var gameMode: Bool = true
    
    var startTime: String = ""
    var endTime: String = ""
    
    var completed: Bool = true
    var repetition: Int = 0
    
    var buttonList: [[String: Int]]?
}
