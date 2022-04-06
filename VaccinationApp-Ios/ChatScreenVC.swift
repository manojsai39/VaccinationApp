//
//  ChatScreenVC.swift
//  VaccinationApp
//
//  Created by 2022M3 on 17/03/22.
//

import UIKit


class MessageModel{
    var msg: String!
    var userType: MessageUser!
    
    init(msg: String,userType: MessageUser){
        self.msg = msg
        self.userType = userType
    }
}

enum MessageUser{
    case sender
    case receiver
}

class ChatScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dictMsg.allKeys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !self.arrMsg.isEmpty{
            return  (dictMsg.value(forKey : arrSort[section]) as! NSArray).count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let array :  [Dictionary<String,Any>] = dictMsg.value(forKey:arrSort[indexPath.section] ) as! [Dictionary<String, Any>]
        let isAdmin : Bool = array[indexPath.row][kIsAdmin] as! Bool
        let date = (array[indexPath.row][kServerTime] as? Timestamp)?.dateValue() ?? Date()
        let data = array[indexPath.row]
        
        
        
        if self.isAdminData {
            if isAdmin {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
                cell.lblMessage.text = data[kMessage] as? String
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
                cell.lblMessage.text = data[kMessage] as? String
                cell.selectionStyle = .none
                return cell
            }
        }
        
        if isAdmin {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
            cell.lblMessage.text = data[kMessage] as? String
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
            cell.lblMessage.text = data[kMessage] as? String
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var vwText: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tvMsg: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    
    
    
    var arrChat = [MessageModel]()
    var refGetMsg : ListenerRegistration? = nil
    var strDocumentName = "\(GFunction.user.emailId.description)_Admin"
    var userName = "Admin"
    var arrMsg  : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
    var arrRecentChatData : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
    let dictMsg : NSMutableDictionary = NSMutableDictionary()
    var arrSort = [String]()
    var isAdminData: Bool = false
    
    func setUPChat() {
        self.arrChat.append(MessageModel(msg: "Hello", userType: .sender))
        self.arrChat.append(MessageModel(msg: "Hey Buddy", userType: .receiver))
        self.arrChat.append(MessageModel(msg: "How are you?", userType: .receiver))
        self.arrChat.append(MessageModel(msg: "Good", userType: .sender))
    }
    
    
    @IBAction func btnSignOutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if !(self.tvMsg.text.trim().isEmpty || self.tvMsg.text.trim() == "Write here..".trim()){
//            self.arrChat.append(MessageModel(msg: self.tvMsg.text,userType: .receiver))
            if self.isAdminData {
                self.sendMessage(msg: self.tvMsg.text, userName: arrRecentChatData[0][kReceiverName] as! String, data1: arrRecentChatData[0][kSenderName] as! String)
            }else{
                self.sendMessage(msg: self.tvMsg.text, userName: GFunction.user.emailId, data1: "Admin")
            }
            
            
        }
        self.tvMsg.text = "Write here.."
        self.tblChat.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GFunction.user.emailId == "Admin@admin.com" {
            self.isAdminData = true
        }
        self.lblName.text = isAdminData ? arrRecentChatData[0][kReceiverName] as? String : userName
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        self.getMesssages()
        self.vwText.layer.borderWidth = 1
        self.vwText.layer.borderColor = UIColor.colorLine.cgColor
        // Do any additional setup after loading the view.
    }
    
}


class SenderCell: UITableViewCell {
    @IBOutlet weak var lblMessage: EdgeInsetLabel!
    @IBOutlet weak var vwSender: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblMessage.layer.cornerRadius = 10
    }
}

class ReceiverCell: UITableViewCell {
    @IBOutlet weak var lblMessage: EdgeInsetLabel!
    @IBOutlet weak var vwReceiver: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblMessage.layer.cornerRadius = 10
    }
}


extension ChatScreenVC {
    func sendMessage(msg:String, userName:String, data1: String)  {
        
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(kChatTable).addDocument(data:
                                                                        [ kMessage: msg,
                                                                          kChatId : self.strDocumentName,
                                                                      kServerTime : FieldValue.serverTimestamp(),
                                                                       kSenderName: data1,
                                                                         kIsAdmin : self.isAdminData,
                                                                     kReceiverName: userName
                                                                        ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                AppDelegate.shared.db.collection(kRecentChatTable).document(self.strDocumentName).setData(
                    [ kMessage: msg,
                      kChatId : self.strDocumentName,
                      kServerTime : FieldValue.serverTimestamp(),
                      kSenderName: data1,
                      kIsAdmin : self.isAdminData,
                      kReceiverName: userName
                    ])
            }
        }
        
        self.getMesssages()
    }
    
    func getMesssages()  {
        
        refGetMsg =  AppDelegate.shared.db.collection(kChatTable).whereField(kChatId, isEqualTo: strDocumentName).order(by: kServerTime, descending: false).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    var dictTemp : Dictionary<String,Any>  = diff.document.data()
                    dictTemp["DocumentID"] = diff.document.documentID
                    
                    if self.indexOfID(id:diff.document.documentID) == NSNotFound {
                        
                        self.arrMsg.append(dictTemp)
                        print("add city: ")
                    }
                    
                }
                if (diff.type == .modified) {
                    //print("Modified city: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                    //let index = self.indexOfID(id:diff.document.documentID)
                    if self.indexOfID(id:diff.document.documentID) != NSNotFound {
                        self.arrMsg.remove(at: self.indexOfID(id:diff.document.documentID))
                    }
                    
                }
            }
            
            // sort array and table reload
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"//"YYYY-MM-dd hh:mm a" // dont change this format
            
            self.dictMsg.removeAllObjects()
            _ = self.arrMsg.filter({ (dataObj: [String : Any]) -> Bool in
                
                let data = (dataObj[kServerTime] as? Timestamp)?.dateValue() ?? Date()
                let strDate = GFunction.shared.UTCToLocalShortDate(date: data)
                
                if (self.dictMsg.allKeys as! Array).contains(strDate) {
                    
                    var arrTemp : [Any] = self.dictMsg.value(forKey:strDate) as! [Any]
                    arrTemp.append(dataObj)
                    
                    self.dictMsg.setValue(arrTemp, forKey: strDate)
                } else {
                    self.dictMsg.setValue([dataObj], forKey:strDate )
                }
                
                return true
            })
            print(self.dictMsg)
            self.sortArray()
            
            self.tblChat.reloadData()
            self.scrollToBottom()
        }
        
    }
    
    func indexOfID(id: String) -> Int {
        
        return self.arrMsg.index{ (question) -> Bool in
            return question["DocumentID"] as! String == id
            
        } ?? NSNotFound
        
    }
    
    func scrollToBottom(){
        let section = dictMsg.allKeys.count - 1
        if section != -1 {
            let row = (dictMsg.value(forKey : arrSort[section]) as! NSArray).count - 1
            //DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: section)
            self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    //}
    
    func sortArray()  {
        
        let testArray = dictMsg.allKeys as! [String]
        var convertedArray: [Date] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        for dat in testArray {
            let date = dateFormatter.date(from: dat)
            if let date = date {
                
                convertedArray.append(date)
            }
        }
        
        let  arrDate = convertedArray.sorted(by: { $0.compare($1) == .orderedAscending })
        
        var  arrConvertedString = [String]()
        for dat in arrDate {
            let date = dateFormatter.string(from:dat)
            arrConvertedString.append(date)
        }
        arrSort = arrConvertedString
    }
}
