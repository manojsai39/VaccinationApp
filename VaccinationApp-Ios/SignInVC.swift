//
//  SignInVC.swift
//  VaccinationApp
//
//  Created by 2022M3 on 14/03/22.
//

import UIKit

class SignInVC: UIViewController {

    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txtPassword: SkyFloatingTextField!
    @IBOutlet weak var txtEmail: SkyFloatingTextField!
    
    //MARK:- Class Variables
    var flag: Bool = true
    
    @IBAction func btnSignInClick(_ sender: UIButton) {
        let err = self.validation()
        if  err == "" {
            if self.txtEmail.text?.trim() == "Admin@admin.com" && self.txtPassword.text?.trim() == "Admin123" {
                UIApplication.shared.setAdmin()
            }else{
                self.loginUser(email: (self.txtEmail.text?.trim())!, password: (self.txtPassword.text?.trim())!)
            }
           
        }else{
            Alert.shared.showAlert(message: err, completion: nil)
        }
    }
    
    @IBAction func btnForgotPasswordClick(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: ForgotPasswordVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else{
            return ""
        }
    }
    
    
    func setUpView(){
        self.txtEmail.text = ""
        self.txtPassword.text = ""
        self.btnSignIn.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}


//MARK:- Extension for Login Function
extension SignInVC {
    
   
    func loginUser(email:String,password:String) {
    
        _ = AppDelegate.shared.db.collection(kUser).whereField(kEmail, isEqualTo: email).whereField(kPassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                if let email : String = snapshot.documents[0].data()["email"] as? String {
                    GFunction.shared.firebaseLogin(data: email)
                    UIApplication.shared.setTab()
                    UserDefaults.standard.set(true, forKey: UserDefaults.Keys.currentUser)
                    UserDefaults.standard.synchronize()
                    GFunction.user = UserModel(id: 0, emailId: email)
                }
            }else{
                if self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = false
                }
            }
        }
        
    }
}
