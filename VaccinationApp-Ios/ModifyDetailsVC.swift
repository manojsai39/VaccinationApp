//
//  ModifyDetailsVC.swift
//  VaccinationApp
//
//  Created by Hrushi on 15/03/22.
//

import UIKit

class ModifyDetailsVC: UIViewController {

    @IBOutlet weak var txtName: SkyFloatingTextField!
    @IBOutlet weak var txtLastName: SkyFloatingTextField!
    @IBOutlet weak var txtAge: SkyFloatingTextField!
    @IBOutlet weak var txtGender: SkyFloatingTextField!
    @IBOutlet weak var txtDate: SkyFloatingTextField!
    @IBOutlet weak var btnModfify: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    var dpDateTime = UIDatePicker()
    var dpGender = UIPickerView()
    var arrayGender = ["Male","Female","Other"];
    var data: OrderModel!
    
    func createDatePicker(){
        
        dpDateTime.backgroundColor = UIColor.black
        dpDateTime.preferredDatePickerStyle = .wheels
        dpDateTime.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        
        var components = DateComponents()
        components.month = 2
        dpDateTime.minimumDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(), to: Date())
        dpDateTime.maximumDate = Calendar(identifier: .gregorian).date(byAdding: components, to: Date())
        txtDate.inputView = dpDateTime
        txtGender.inputView = dpGender
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.green
        toolBar.sizeToFit()
        toolBar.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtDate.inputAccessoryView = toolBar
        txtGender.inputAccessoryView = toolBar
        dpDateTime.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }
    
    
    @objc func cancelClick() {
        txtDate.resignFirstResponder()
        txtGender.resignFirstResponder()
    }

    @objc func changeValue(){
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.dateFormat = "dd-MM-yyyy hh:mm a"
        self.txtDate.text = dateFormatter1.string(from: dpDateTime.date)
    }
    
    
    func validation() -> String {
        
        if self.txtName.text?.trim() == "" {
            return "Please enter first name"
        }else if self.txtLastName.text?.trim() == "" {
            return "Please enter last name"
        }else if self.txtAge.text?.trim() == ""{
            return "Please enter age"
        }else if self.txtGender.text?.trim() == "" {
            return "Please select gender"
        }else if self.txtDate.text?.trim() == "" {
            return "Please enter date"
        }
        return ""
    }
    
    @IBAction func btnModifyClick(_ sender: UIButton) {
        let error = self.validation()
        if error == ""{
            self.updateOrder(data: self.data, firstName: (self.txtName.text?.trim())!, lastName: (self.txtLastName.text?.trim())!, age: (self.txtAge.text?.trim())!, gender: (self.txtGender.text?.trim())!, date: (self.txtDate.text?.trim())!)
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        UIApplication.shared.setTab()
    }
    
    @IBAction func btnSignOutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDate.delegate = self
        self.txtGender.delegate = self
        self.dpGender.delegate = self
        self.dpGender.dataSource = self
        
        
        self.btnCancel.layer.cornerRadius = 10
        self.btnDelete.layer.cornerRadius = 10
        self.btnModfify.layer.cornerRadius = 10
        
        self.createDatePicker()
        
        if self.data != nil {
            self.setUpData()
        }
        
        // Do any additional setup after loading the view.
    }

    func setUpData(){
        self.txtDate.text = data.date
        self.txtGender.text = data.gender
        self.txtAge.text = data.age
        self.txtName.text = data.firstName
        self.txtLastName.text = data.lastName
    }
    
    func updateOrder(data:OrderModel,firstName:String,lastName:String,age:String,gender:String,date:String) {
        let ref = AppDelegate.shared.db.collection(kOrder).document(data.docID)
        ref.updateData([
            kHospitalName : data.hospitalName.description,
            kFirstName: firstName,
            kLastName: lastName,
            kAge: age,
            kGender: gender,
            kDate: date
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                //self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                UIApplication.shared.setTab()
            }
        }
    }
}

extension ModifyDetailsVC  :UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayGender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayGender[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtGender.text = arrayGender[row].description
    }
}
