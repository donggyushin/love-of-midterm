//
//  Try.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct Try {
    let date:Date
    let from:String
    let to:String
    
    init(data:[String:Any]) {
        let date = data["date"] as? Timestamp ?? Timestamp()
        let from = data["from"] as? String ?? ""
        let to = data["to"] as? String ?? ""
        
        self.date = date.dateValue()
        self.from = from
        self.to = to 
    }
}
