//
//  Address.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/15.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation

struct AddressResponse:Codable {
    let items:[Address]
}

struct Address:Codable {
    var id:String?
    var userId:String?
    let title:String
    let link:String
    let category:String
    let description:String
    let telephone:String
    let address:String
    let roadAddress:String
    let mapx:String
    let mapy:String
    
    
    init(data:[String:Any]){
        let address = data["address"] as? String ?? ""
        let category = data["category"] as? String ?? ""
        let description = data["description"] as? String ?? ""
        let id = data["id"] as? String ?? ""
        let link = data["link"] as? String ?? ""
        let mapx = data["mapx"] as? String ?? ""
        let mapy = data["mapy"] as? String ?? ""
        let roadAddress = data["roadAddress"] as? String ?? ""
        let telephone = data["telephone"] as? String ?? ""
        let title = data["title"] as? String ?? ""
        let userId = data["userId"] as? String ?? ""
        
        self.address = address
        self.category = category
        self.description = description
        self.id = id
        self.link = link
        self.mapx = mapx
        self.mapy = mapy
        self.roadAddress = roadAddress
        self.telephone = telephone
        self.title = title
        self.userId = userId
    }
    
}
