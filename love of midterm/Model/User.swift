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
    let requestsISend:[String]
    let requestsIReceived:[String]
    let chatIds:[String]
    let unreadMessages:[String]
    let matchedUsers:[String]
    let playerId:String
    let allowNotification:Bool
    
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
        let requestsISend = data["requestsISend"] as? [String] ?? []
        let requestsIReceived = data["requestsIReceived"] as? [String] ?? []
        let chatIds = data["chatIds"] as? [String] ?? []
        let unreadMessages = data["unreadMessages"] as? [String] ?? []
        let matchedUsers = data["matchedUsers"] as? [String] ?? []
        let playerId = data["playerId"] as? String ?? ""
        let allowNotification = data["allowNotification"] as? Bool ?? true
        
        
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
        self.requestsISend = requestsISend
        self.requestsIReceived = requestsIReceived
        self.chatIds = chatIds
        self.unreadMessages = unreadMessages
        self.matchedUsers = matchedUsers
        self.playerId = playerId
        self.allowNotification = allowNotification
        
    }
    
}
