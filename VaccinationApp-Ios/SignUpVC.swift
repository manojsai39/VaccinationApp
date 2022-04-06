//
//  SignUpVC.swift
//  VaccinationApp
//
//  Created on 14/03/22.
//

import UIKit
import FirebaseFirestore

class SignUpVC: UIViewController {

    @IBOutlet weak var txtEmail: SkyFloatingTextField!
    @IBOutlet weak var txtPassword: SkyFloatingTextField!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignInWithApple: UIButton!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingTextField!
    
    //MARK:- Class Variables
    var flag: Bool = false
    private let appleLoginManager: AppleLoginManager = AppleLoginManager()
    
    func setUpView(){
        self.btnSignUp.layer.cornerRadius = 5
        self.btnSignInWithApple.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.imgCheck.isHighlighted.toggle()
        }
        
        self.imgCheck.isUserInteractionEnabled = true
        self.imgCheck.addGestureRecognizer(tap)
    }
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if self.txtConfirmPassword.text?.trim() == "" {
            return "Please enter confirm password"
        }else if self.txtPassword.text?.trim() != self.txtConfirmPassword.text?.trim() {
            return "Password mismatched"
        }else{
            return ""
        }
    }
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        if sender == btnSignIn {
            let err = self.validation()
            if err == "" {
                self.getExistingUser(email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", confirmPassword: self.txtConfirmPassword.text ?? "")
            }else{
                Alert.shared.showAlert(message: err, completion: nil)
            }
        }else if sender == btnSignInWithApple {
            self.appleLoginManager.performAppleLogin()
        }
    }
    
    @IBAction func btnSignInClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }

}


//MARK:- Extension for Login Function
extension SignUpVC {
    
    func createAccount(email:String,password:String,confirmPassword:String) {
        var ref : DocumentReference? = nil
       
        ref = AppDelegate.shared.db.collection(kUser).addDocument(data:
            [
              kEmail: email,
              kPassword : password,
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                GFunction.shared.firebaseLogin(data: email)
                GFunction.user = UserModel(id: 0, emailId: email)
                UIApplication.shared.setTab()
                self.flag = true
            }
        }
    }
    
    func getExistingUser(email:String,password:String,confirmPassword:String) {
    
        _ = AppDelegate.shared.db.collection(kUser).whereField(kEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count == 0 {
                self.createAccount(email: email, password: password, confirmPassword: confirmPassword)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "UserName already exist !!!", completion: nil)
                    self.flag = true
                }
            }
        }
    }
    

    
    func appleLoginData(data: AppleLoginModel) {
        
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
        
        
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
            //            vc.isApple = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
