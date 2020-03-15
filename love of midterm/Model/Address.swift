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
    let title:String
    let link:String
    let category:String
    let description:String
    let telephone:String
    let address:String
    let roadAddress:String
    let mapx:String
    let mapy:String
}
