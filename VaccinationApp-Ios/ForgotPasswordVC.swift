

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail: SkyFloatingTextField!
    @IBOutlet weak var txtOTP: SkyFloatingTextField!
    @IBOutlet weak var txtPassword: SkyFloatingTextField!
    @IBOutlet weak var txtConfirmOTP: SkyFloatingTextField!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    var flag = true
    
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtOTP.text?.trim() == "" {
            return "Please enter OTP"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if self.txtConfirmOTP.text?.trim() == "" {
            return "Please enter confirm password"
        }else if self.txtPassword.text?.trim() != self.txtConfirmOTP.text?.trim() {
            return "Password mismatched"
        }
        return ""
    }
    
    @IBAction func btnConfirmClick(_ sender: Any) {
        let error = self.validation()
        if error == "" {
            self.checkUser(email: (self.txtEmail.text?.trim())!, password: (self.txtPassword.text?.trim())!)
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtOTP.delegate = self
        self.btnConfirm.layer.cornerRadius = 6
        // Do any additional setup after loading the view.
    }
    
func checkUser(email:String,password:String) {
    
    _ = AppDelegate.shared.db.collection(kUser).whereField(kEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
        
        guard let snapshot = querySnapshot else {
            print("Error fetching snapshots: \(error!)")
            return
        }
        
        if snapshot.documents.count != 0 {
            let data = snapshot.documents[0]
            self.updatePAssword(docID: data.documentID, password: password)
            self.flag = false
        }else{
            if self.flag {
                Alert.shared.showAlert(message: "Please enter valid email address !!!", completion: nil)
                self.flag = false
            }
        }
    }
}
    
func updatePAssword(docID: String,password:String) {
    let ref = AppDelegate.shared.db.collection(kUser).document(docID)
    ref.updateData([
        kPassword : password
    ]){ err in
        if let err = err {
            print("Error updating document: \(err)")
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Document successfully updated")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

}


extension ForgotPasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //TxtMobileNumber allowed only Digits, and maximum 10 Digits allowed
        if textField == self.txtOTP {
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 4) || string.isEmpty{
                return true
            }
            return false
        }
        return true
    }
}
