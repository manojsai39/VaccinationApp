//
//  ExistingListVC.swift
//  VaccinationApp
//
//  Created by Hrushi on 15/03/22.
//

import UIKit

class ExistingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblList: UITableView!
    
    
    var arrData = [OrderModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPendingData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentBookedCell") as! AppointmentBookedCell
        let data = self.arrData[indexPath.row]
        cell.configCell(data: data)
        //cell.configCell(data: self.arraySideMenuItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func btnSignOutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }

    
    func getPendingData() {
        _ = AppDelegate.shared.db.collection(kOrder).whereField(kEmail, isEqualTo: GFunction.user.emailId!).whereField(kStatus, isNotEqualTo: kCancelled).addSnapshotListener{ querySnapshot, error in
            
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
            }
        }
    }
}


class AppointmentBookedCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblHospital : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var vwCell : UIView!
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 20
    }
    
    
    func configCell(data: OrderModel) {
        let time = data.date.suffix(9)
        let date = data.date.dropLast(9)
        self.lblName.text = "\(data.firstName.description) \(data.lastName.description)"
        self.lblDate.text = "Date: \(date.description)"
        self.lblTime.text = "Time:\(time.description)"
        self.lblHospital.text = "Hospital Name: \(data.hospitalName.description)"
    }
    
}
