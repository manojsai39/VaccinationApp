import UIKit

class ConfirmedBookingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelledCell") as! CancelledCell
        cell.lblCancel.text = "Confirmed"
        cell.configCell(data: self.arrData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    

    @IBOutlet weak var tblList: UITableView!
    var arrData = [OrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tblList.delegate = self
//        self.tblList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getConfirmedData()
    }
    
    func getConfirmedData() {
        _ = AppDelegate.shared.db.collection(kOrder).whereField(kStatus, isEqualTo: kConfirmed).addSnapshotListener{ querySnapshot, error in
            
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
