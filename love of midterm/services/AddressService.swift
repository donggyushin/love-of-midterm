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
    
    
    func calculateTwoDistance(id1:String, id2:String, completion:@escaping(Error?, String?) -> Void){
        
        db.collection("addresses").document(id1).getDocument { (querySnapshot, error) in
            
            if let error = error {
                completion(error, nil)
            }else {
                
                guard let data = querySnapshot!.data() else { return }
                let address1 = Address(data: data)
                
                self.db.collection("addresses").document(id2).getDocument { (querySnapshot, error) in
                    if let error = error {
                        completion(error, nil)
                    }else {
                        
                        guard let data = querySnapshot!.data() else { return }
                        let address2 = Address(data: data)
                        
                        guard let x1 = Float(address1.mapx) else { return }
                        guard let x2 = Float(address2.mapx) else { return }
                        guard let y1 = Float(address1.mapy) else { return }
                        guard let y2 = Float(address2.mapy) else { return }
                        
                        
                        
                        let distance = (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2))).squareRoot() / 1000
                        let formattedDistance = String(format: "%.1f", distance)
                        
                        completion(nil, formattedDistance)
                    }
                }
                
            }
        }
    }
    
    
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
