//
//  Chat.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/25.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct Chat {
    let id:String
    let users:[String]
    let createdAt:Date
    let updatedAt:Date
    let lastMessage:String
    
    init(data:[String:Any]) {
        let id = data["id"] as? String ?? ""
        
        let users = data["users"] as? [String] ?? []
        let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
        let updatedAt = data["updatedAt"] as? Timestamp ?? Timestamp()
        let lastMessage = data["lastMessage"] as? String ?? ""
        
        self.id = id
        self.users = users
        self.createdAt = createdAt.dateValue()
        self.updatedAt = updatedAt.dateValue()
        self.lastMessage = lastMessage
    }
    
}
