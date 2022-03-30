//
//  OrderModel.swift
//  VaccinationApp
//


import Foundation


class OrderModel {
    var docID: String!
    var emailId: String!
    var hospitalName: String!
    var date: String!
    var gender: String!
    var age: String!
    var firstName: String!
    var lastName: String!
    var status: String!

    init(docID: String, emailId:String, hospitalName:String, date:String, gender:String, age:String, firstName:String, lastName:String, status:String){
        
        self.emailId = emailId
        self.date = date
        self.hospitalName = hospitalName
        self.gender = gender
        self.age = age
        self.firstName = firstName
        self.lastName = lastName
        self.status = status
        self.docID = docID
    }
    
    init(){
    }
}
