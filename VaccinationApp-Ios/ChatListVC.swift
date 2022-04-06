import UIKit

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrRecentChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data =  self.arrRecentChat[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        cell.lblName.text = data[kReceiverName] as? String
        cell.lblMessage.text = data[kMessage] as? String
        cell.vwMain.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: ChatScreenVC.self) {
                vc.strDocumentName = data[kChatId] as? String ?? ""
                vc.arrRecentChatData = [data]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwMain.addGestureRecognizer(tap)
        cell.selectionStyle = .none
        return cell
    }
    

    @IBOutlet weak var tblList: UITableView!
    
    var isKey = ""
    var arrRecentChat : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
   
    @IBAction func btnSignOutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblList.delegate = self
        self.tblList.dataSource = self
        self.getMesssages()
        // Do any additional setup after loading the view.
    }
}


class ChatListCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    override func awakeFromNib() {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
    }
}

extension ChatListVC {
    func eventListener(snapshot :QuerySnapshot)  {
        
       
        snapshot.documentChanges.forEach { diff in
            
            if (diff.type == .added) {
                
                if self.indexOfID(id:diff.document.documentID) == NSNotFound  {
                    var dictTemp : Dictionary<String,Any>  = diff.document.data()
                    dictTemp["DocumentID"] = diff.document.documentID
                    
                    self.arrRecentChat.append(dictTemp)
                    print("add city: ")
                }
                
                self.arrRecentChat = self.arrRecentChat.map({ (obj) -> Dictionary<String,Any> in
                    var data = obj
                    data["status"] = false
                    
                    return data
                })
                
               
                self.tblList.reloadData()
                
            }
            
            if (diff.type == .modified) {
                
                let index = self.indexOfID(id:diff.document.documentID)
                
                if index > self.arrRecentChat.count - 1 {
                    return
                }
                
                self.arrRecentChat.remove(at: index)
                
                var dictTemp : Dictionary<String,Any>  = diff.document.data()
                dictTemp["DocumentID"] = diff.document.documentID
                
                self.arrRecentChat.append(dictTemp)
                
                self.arrRecentChat = self.arrRecentChat.map({ (obj) -> Dictionary<String,Any> in
                    var data = obj
                    data["status"] = false
                    
                    return data
                })
                
               
                self.tblList.reloadData()
            }
        }
    }
    
    func indexOfID(id: String) -> Int {
        
        return self.arrRecentChat.firstIndex { (question) -> Bool in
            return question["DocumentID"] as! String == id
            
            } ?? NSNotFound
        
    }
    
    func getMesssages() {
        
        AppDelegate.shared.db.collection(kRecentChatTable).order(by: kServerTime, descending: true).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            self.eventListener(snapshot:snapshot)
        }

    }
//    func showBadgeCount(count: Int, conversationCell: UITableViewCell) {
//        conversationCell.contentView.viewWithTag(17190)?.removeFromSuperview()
//        if count != 0 {
//            // Create label
//            let fontSize: CGFloat = 10
//
//            let label:UILabel = UILabel(frame: CGRect(x: conversationCell.frame.width - 50, y: 35, width: 10, height: 10))
//
//            //                label = UILabel (frame: CGRectMake(MainScreen.width - 30, 20, 10, 10))
//            label.backgroundColor = .purple
//            //     label.isHidden = true
//            label.font = UIFont.customFont(ofType: .medium, withSize: kfontsize10)
//            label.textAlignment = .center
//            label.textColor = .white
//
//            // Add count to label and size to fit
//            label.text = "\(1)"
//            label.sizeToFit()
//            // Adjust frame to be square for single digits or elliptical for numbers > 9
//            var frame: CGRect = label.frame
//            frame.size.height += CGFloat(0.4 * fontSize)
//            frame.size.width = (count <= 9) ? frame.size.height : frame.size.width + CGFloat(fontSize)
//            label.frame = frame
//            // Set radius and clip to bounds
//            label.layer.cornerRadius = frame.size.height / 2.0
//            label.clipsToBounds = true
//            label.tag = 17190
//
//            conversationCell.contentView.addSubview(label)
//
//        }
//        else {
//            conversationCell.accessoryView = nil
//        }
//    }
}
