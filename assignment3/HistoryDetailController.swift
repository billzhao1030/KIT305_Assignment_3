
import UIKit

class HistoryDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var rightClick: UILabel!
    @IBOutlet var totalClick: UILabel!
    
    @IBOutlet var buttonListTable: UITableView!
    @IBOutlet var image: UIImageView!
    
    
    var game : Game?
    var gameIndex : Int?
    
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonClickCell", for: indexPath)
        
        let buttonClick = buttonList[indexPath.row]

        if let clickCell = cell as? ButtonClickCell {
            
            var time = buttonClick.keys
            var value = buttonClick.values
            
            
            if (value.contains(10) || value.contains(20) || value.contains(30) || value.contains(40) || value.contains(50)) == true {
                clickCell.buttonClick.textColor = UIColor.red
            } else {
                clickCell.buttonClick.textColor = UIColor.black
            }
            
            var timeStr = "\(time)"[2..<10]
            var clickStr = "\(value)"[1..<2]
            
            clickCell.buttonClick.text = "\(timeStr) : \(clickStr)"
        }
        
        return cell
    }
    
    func calculateClick() {
        if let displayedGame = game {
            buttonList = displayedGame.buttonList ?? []
            var right = 0
            var total = 0
            for click in buttonList {
                var value = click.values
                total += 1
                if (value.contains(10) || value.contains(20) || value.contains(30) || value.contains(40) || value.contains(50)) == false {
                    right += 1
                }
            }
            
            rightClick.text = "The right click : \(right)"
            totalClick.text = "The total click : \(total)"
            
            self.buttonListTable.reloadData()
        }
    }
    
    func showElements(_ isShow: Bool) {
        rightClick.isHidden = isShow
        totalClick.isHidden = isShow
        image.isHidden = isShow
    }
    
    
    @IBAction func shareThis(_ sender: Any) {
    }
    
    
    @IBAction func deleteThis(_ sender: Any) {
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


