//
//  UITextField+Extension.swift
//  VaccinationApp
//
//  Created by 2022M3 on 14/03/22.
//

import Foundation
import SkyFloatingLabelTextField


class SkyFloatingTextField: SkyFloatingLabelTextField {
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedTitleColor = .blue
        self.titleColor = .lightGray
        self.lineColor = .lightGray
        self.selectedLineColor = .blue
        
    }

}
