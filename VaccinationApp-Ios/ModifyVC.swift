//
//  ModifyVC.swift
//  VaccinationApp
//
//  Created by 2022M3 on 15/03/22.
//

import UIKit

class ModifyVC:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnModify: UIButton!
    
    var arrData = [OrderModel]()
    
    
    @IBAction func btnModifyClick(_ sender:  UIButton){
        
    }
    
    @IBAction func btnSignOutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnModify.layer.cornerRadius = 10
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
        cell.selectionStyle = .none
        cell.vwCell.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: HospitalListVC.self) {
                vc.data = data
                vc.isEdit = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwCell.addGestureRecognizer(tap)
        return cell
    }

    
    //if you want to modify and display all the request which is not rejected then use below line replace this two lines
    // _ = AppDelegate.shared.db.collection(kOrder).whereField(kEmail, isEqualTo: GFunction.user.emailId!).whereField(kStatus, isNotEqualTo: kCancelled).addSnapshotListener{ querySnapshot, error in
    
    func getPendingData() {
        _ = AppDelegate.shared.db.collection(kOrder).whereField(kEmail, isEqualTo: GFunction.user.emailId!).whereField(kStatus, isEqualTo: kPending).addSnapshotListener{ querySnapshot, error in
            
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
