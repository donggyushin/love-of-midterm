//
//  Message.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/26.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let sender:String
    let chatId:String
    let id:String
    let read:Bool
    let text:String
    let type:String
    let createdAt:Date
    
    init(data:[String:Any]) {
        let sender = data["sender"] as? String ?? ""
        let chatId = data["chatId"] as? String ?? ""
        let id = data["id"] as? String ?? ""
        let read = data["read"] as? Bool ?? true
        let text = data["text"] as? String ?? ""
        let type = data["type"] as? String ?? ""
        let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
        
        self.sender = sender
        self.chatId = chatId
        self.id = id
        self.read = read
        self.text = text
        self.type = type
        self.createdAt = createdAt.dateValue()
    }
}
