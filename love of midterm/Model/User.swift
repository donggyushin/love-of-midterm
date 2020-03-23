//
//  User.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/14.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct User {
    let email:String
    let id:String
    let profileImageReference:String
    let profileImageUrl:String
    let username:String
    let bio:String
    let backgroundImages:[String]
    let addressId:String
    let birthday:Date
    let gender:String
    let testIds:[String]
    let tryFrom:[String]
    let tryTo:[String]
    
    init(data:[String:Any]) {
        let email = data["email"] as? String ?? ""
        let id = data["id"] as? String ?? ""
        let profileImageReference = data["profileImageReference"] as? String ?? ""
        let profileImageUrl = data["profileImageUrl"] as? String ?? ""
        let username = data["username"] as? String ?? ""
        let bio = data["bio"] as? String ?? ""
        let backgroundImages = data["backgroundImages"] as? [String] ?? []
        let addressId = data["addressId"] as? String ?? ""
        let birthday = data["birthday"] as? Timestamp ?? Timestamp()
        let gender = data["gender"] as? String ?? ""
        let testIds = data["testIds"] as? [String] ?? []
        let tryFrom = data["tryFrom"] as? [String] ?? []
        let tryTo = data["tryTo"] as? [String] ?? []
        
        
        self.email = email
        self.id = id
        self.profileImageReference = profileImageReference
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.bio = bio
        self.backgroundImages = backgroundImages
        self.addressId = addressId
        self.birthday = birthday.dateValue()
        self.gender = gender
        self.testIds = testIds
        self.tryTo = tryTo
        self.tryFrom = tryFrom
        
    }
    
}
