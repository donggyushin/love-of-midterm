//
//  AddressService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/17.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct AddressService {
    static let shared = AddressService()
    let db = Firestore.firestore()
    func fetchAddress(user:User, completion:@escaping(Error?, Address?) -> Void){
        db.collection("users").document(user.id).getDocument { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                let data = querySnapshot!.data()!
                guard let addressId = data["addressId"] as? String else { return }
                self.db.collection("addresses").document(addressId).getDocument { (querySnapshot, error) in
                    if let error = error {
                        completion(error, nil)
                    }else {
                        let data = querySnapshot!.data()!
                        let address = Address(data: data)
                        completion(nil, address)
                    }
                }
            }
        }
    }
}
