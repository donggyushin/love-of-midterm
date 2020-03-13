//
//  User.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/14.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation


struct User {
    let email:String
    let id:String
    let profileImageReference:String
    let profileImageUrl:String
    let username:String
    let bio:String
    let backgroundImages:[String]
    
    init(data:[String:Any]) {
        let email = data["email"] as? String ?? ""
        let id = data["id"] as? String ?? ""
        let profileImageReference = data["profileImageReference"] as? String ?? ""
        let profileImageUrl = data["profileImageUrl"] as? String ?? ""
        let username = data["username"] as? String ?? ""
        let bio = data["bio"] as? String ?? ""
        let backgroundImages = data["backgroundImages"] as? [String] ?? []
        
        self.email = email
        self.id = id
        self.profileImageReference = profileImageReference
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.bio = bio
        self.backgroundImages = backgroundImages
    }
}
