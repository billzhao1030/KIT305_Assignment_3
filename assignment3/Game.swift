
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
    
    var totalClick: Int?
    var rightClick: Int?
    
    func toShare() -> String {
        var type = (gameType == true) ? "number in order" : "matching numbers"
        var complete = (completed == true) ? "" : "not "
        
        var buttonClickStr = "{"
        for click in buttonList! {
            var time = "\(click.keys)"[2..<10]
            var button = "\(click.values)"[1..<2]
            buttonClickStr += "(\(time) : \(button)) "
        }
        buttonClickStr += "}"
        
        
        var prescribed = (gameType == true) ? "total press of buttons: \(totalClick!), " +
        "correct press of buttons: \(rightClick!), The button list: \(buttonClickStr)" : ""
        
        
        return "Exercise: \(type) \(complete) completed, Start at: \(startTime), End at: \(endTime), " +
               " \(repetition) round(s) in total, \(prescribed)"
    }
    
    func toSummary(_ isRound: Bool, _ isFree: Bool) -> String {
        var type = (gameType == true) ? "Number in order" : "Matching numbers"
        
        var extra = ""
        if isFree == true {
            extra += "From \(startTime)\nTo \(endTime)\n With \(repetition) round(s) in total"
        } else {
            if isRound == true {
                extra += "From \(startTime)\nTo \(endTime)"
            } else {
                extra += "With \(repetition) round(s) in total"
            }
        }
        
        return "Congratulations!\nYou have completed \(type) exercise\n" +
               "\(extra)"
    }
}
