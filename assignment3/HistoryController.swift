
import UIKit

class HistoryController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareAllHistory(_ sender: Any) {
        let shareView = UIActivityViewController (
            activityItems: ["nice history to share"],
            applicationActivities: [])
        present(shareView, animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
