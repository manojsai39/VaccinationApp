//
//  HomeVC.swift
//  VaccinationApp
//
//  Created by Hrushi on 15/03/22.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var btnDisplay: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var btnContactus: UIButton!
    
    
    @IBAction func btnDisplayClick(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: ExistingListVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnModifyClick(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: ModifyVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSignOutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    @IBAction func btnBook(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: HospitalListVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnContactUS(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: ChatScreenVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setUpView(){
        self.btnDisplay.layer.borderColor = UIColor.colorLine.cgColor
        self.btnDisplay.layer.borderWidth = 1
        self.btnDisplay.layer.cornerRadius = 10
        self.btnEdit.layer.cornerRadius = 10
        self.btnBook.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
//        self.setUpOrder()
    }
    
    
    func setData(){
        var data = [HospitalModel]()
        
        data.append(HospitalModel(id: "1", hospitalName: "Hospital 1", address: "0000, Lincoin Avanue", city: "Montreal, Quebec", zipcode: "G2V0J7"))
        data.append(HospitalModel(id: "2", hospitalName: "Hospital 2", address: "1111, Lincoin Avanue", city: "Montreal, Quebec", zipcode: "G2V0J7"))
        data.append(HospitalModel(id: "3", hospitalName: "Hospital 3", address: "2222, Lincoin Avanue", city: "Montreal, Quebec", zipcode: "G2V0J7"))
        data.append(HospitalModel(id: "4", hospitalName: "Hospital 4", address: "3333, Lincoin Avanue", city: "Montreal, Quebec", zipcode: "G2V0J7"))
        data.append(HospitalModel(id: "5", hospitalName: "Hospital 5", address: "4444, Lincoin Avanue", city: "Montreal, Quebec", zipcode: "G2V0J7"))
        
        for hdata in data {
            self.addData(data: hdata)
        }
    }
    
    
    
    func addData(data: HospitalModel) {
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(kHospital).addDocument(data:
                                                                        [ kHospitalName : data.hospitalName.description,
                                                                             kHospitalId: data.id.description,
                                                                                kAddress: data.address.description,
                                                                                  kCity : data.city.description,
                                                                                kZipcode: data.zipcode.description
                                                                        ]
        )
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func addOrderData(data: OrderModel) {
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(kOrder).addDocument(data:
                                                                        [ kHospitalName : data.hospitalName.description,
                                                                             kDate: data.date.description,
                                                                                kAge: data.age.description,
                                                                                  kFirstName : data.firstName.description,
                                                                                kLastName: data.lastName.description,
                                                                                 kGender: data.gender.description,
                                                                               kStatus: data.status.description,
                                                                               kEmail: data.emailId.description
                                                                        ]
        )
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}
