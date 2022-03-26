

import UIKit

class HistoryTableCell: UITableViewCell {

    @IBOutlet var historyTitle: UILabel!
    
    @IBOutlet var historyStart: UILabel!
    @IBOutlet var historyEnd: UILabel!
    
    @IBOutlet var historyComplete: UILabel!
    @IBOutlet var historyRepetition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
