//
//  BookingSuccessVC.swift
//  VaccinationApp
//
//  Created by Hrushi on 15/03/22.
//

import UIKit

class BookingSuccessVC: UIViewController {

    @IBOutlet weak var vwThanks: UIView!
    @IBOutlet weak var vwNotes: UIView!
    @IBOutlet weak var btnHome: UIButton!
   
    
    
    @IBAction func btnHomeClick(_ sender: UIButton) {
        UIApplication.shared.setTab()
    }
    
    @IBAction func btnSignOutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnHome.layer.cornerRadius = 10
        self.vwThanks.layer.cornerRadius = 5
        self.vwThanks.layer.borderColor = UIColor.darkGray.cgColor
        self.vwThanks.layer.borderWidth = 2
        
        self.vwNotes.layer.borderColor = UIColor.red.cgColor
        self.vwNotes.layer.cornerRadius = 10
        self.vwNotes.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }

}
