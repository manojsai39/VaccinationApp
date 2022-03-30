//
//  UserModel.swift


import Foundation


class UserModel {
    var id: Int!
    var emailId: String!

    init(id: Int,emailId:String){
        self.id = id
        self.emailId = emailId
    }
    
    init(){
    }
}
