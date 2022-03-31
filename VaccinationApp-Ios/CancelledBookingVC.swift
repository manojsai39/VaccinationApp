import UIKit

class CancelledBookingVC:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelledCell") as! CancelledCell
        cell.configCell(data: self.arrData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    

    @IBOutlet weak var tblList: UITableView!

    var arrData = [OrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCancelledData()
    }
    
    func getCancelledData() {
        _ = AppDelegate.shared.db.collection(kOrder).whereField(kStatus, isEqualTo: kCancelled).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let date : String = data1[kDate] as? String, let name: String = data1[kHospitalName] as? String, let status: String = data1[kStatus] as? String, let firstName : String = data1[kFirstName] as? String,let lastName : String = data1[kLastName] as? String,let age : String = data1[kAge] as? String, let gender: String = data1[kGender] as? String,let email : String = data1[kEmail] as? String {
                        print("Data Count : \(self.arrData.count)")
                        self.arrData.append(OrderModel(docID: data.documentID, emailId: email, hospitalName: name, date: date, gender: gender, age: age, firstName: firstName, lastName: lastName, status: status))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found", completion: nil)
            }
        }
    }
}




class CancelledCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblCancel: UILabel!
    
    
    override func awakeFromNib() {
        self.vwMain.layer.cornerRadius = 5
        self.vwMain.layer.borderWidth = 2
        self.vwMain.layer.borderColor = UIColor.lightGray.cgColor
        self.vwMain.backgroundColor = UIColor.colorLine
        
    }
    
    func configCell(data: OrderModel) {
        let time = data.date.suffix(9)
        let date = data.date.dropLast(9)
        
        self.lblTime.text = "Time: \(time.description)"
        self.lblDate.text = "Date: \(date.description)"
        self.lblName.text = "Name: \(data.firstName.description) \(data.lastName.description)"
        self.lblId.text = "Booking Id: \(data.docID.description)"
        self.lblHospitalName.text = "Hospital Name: \(data.hospitalName.description)"
    }

}
