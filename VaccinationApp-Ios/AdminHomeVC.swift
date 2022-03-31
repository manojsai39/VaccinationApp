
import UIKit

class AdminHomeVC: UIViewController {

    
    @IBOutlet weak var vwPending: UIView!
    @IBOutlet weak var vwConfirmed: UIView!
    @IBOutlet weak var vwCancelled: UIView!
    @IBOutlet weak var vwChat: UIView!
    
    
    @IBAction func btnSignOutClick(_ sender: Any) {
        UIApplication.shared.setStart()
    }
    
    
    func viewSetUP(sender: UIView, classFile: UIViewController.Type) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.colorLine.cgColor
        sender.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: classFile) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        sender.isUserInteractionEnabled = true
        sender.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewSetUP(sender: self.vwChat, classFile: ChatListVC.self)
        self.viewSetUP(sender: self.vwPending, classFile: PendingBookingVC.self)
        self.viewSetUP(sender: self.vwConfirmed, classFile: ConfirmedBookingVC.self)
        self.viewSetUP(sender: self.vwCancelled, classFile: CancelledBookingVC.self)
        
        // Do any additional setup after loading the view.
    }


}

