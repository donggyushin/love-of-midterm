//
//  BackgroundImage.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/14.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import UIKit
struct BackgroundImage {
    let downloadUrl:String
    let id:String
    let referenceId:String
    let userId:String
    var image:UIImage?
    
    init(downloadUrl:String, id:String, referenceId:String, userId:String){
        self.downloadUrl = downloadUrl
        self.id = id
        self.referenceId = referenceId
        self.userId = userId
    }
    
    init(data:[String:Any]) {
        let downloadUrl = data["downloadUrl"] as? String ?? ""
        let id = data["id"] as? String ?? ""
        let referenceId = data["referenceId"] as? String ?? ""
        let userId = data["userId"] as? String ?? ""
        
        self.downloadUrl = downloadUrl
        self.id = id
        self.referenceId = referenceId
        self.userId = userId
    }
    
    
}
