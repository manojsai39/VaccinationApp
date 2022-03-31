//
//  HospitalDetailsVC.swift
//  VaccinationApp
//
//  Created by manoj on 18/03/22.
//

import UIKit

class HospitalDetailsVC: UIViewController {

    @IBOutlet weak var btnHospital: UIButton!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var vwCheck: UIView!
    
    
    var data: HospitalModel!
    var orderData: OrderModel!
    var isEdit = false
    
    @IBAction func btnSelectHospital(_ sender: UIButton){
        if isEdit {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: ModifyDetailsVC.self){
                vc.data = orderData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddBookingDetailsVC.self){
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwCheck.layer.cornerRadius = 5
        self.vwCheck.layer.borderColor = UIColor.gray.cgColor
        self.vwCheck.layer.borderWidth = 1
        
        self.btnHospital.layer.cornerRadius = 5
        
        if self.data != nil {
            self.lblName.text = "Hospital Name : \(data.hospitalName.description)"
            self.lblAddress.text = "Address : \(data.address.description)\n\(data.city.description) - \(data.zipcode.description)"
            
            if orderData != nil{
                self.orderData.hospitalName = data.hospitalName
            }
            
        }
        // Do any additional setup after loading the view.
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
