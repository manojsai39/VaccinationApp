//
//  HospitalModel.swift
//  VaccinationApp
//


import Foundation


class HospitalModel {
    var id : String!
    var hospitalName: String!
    var address: String!
    var city: String!
    var zipcode: String!

    init(id:String,hospitalName:String,address:String,city:String,zipcode:String){
        
        self.id = id
        self.hospitalName = hospitalName
        self.address = address
        self.city = city
        self.zipcode = zipcode
    }
    
    init(){
    }
}
