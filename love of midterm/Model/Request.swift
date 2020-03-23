//
//  Request.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase
struct Request {
    let from:String
    let to:String
    let tryCount:Int
    let checked:Bool
    let id:String
    let date:Date
    let dateInt:Int
    
    init(data:[String:Any]) {
        let from = data["from"] as? String ?? ""
        let to = data["to"] as? String ?? ""
        let tryCount = data["tryCount"] as? Int ?? 1
        let checked = data["checked"] as? Bool ?? false
        let id = data["id"] as? String ?? ""
        let date = data["date"] as? Timestamp ?? Timestamp()
        let dateInt = data["dateInt"] as? Int ?? 0
        
        self.from = from
        self.to = to
        self.checked = checked
        self.tryCount = tryCount
        self.id = id
        self.date = date.dateValue()
        self.dateInt = dateInt
    }
}
