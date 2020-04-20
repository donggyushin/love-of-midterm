//
//  TryService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct TryService {
    static let shared = TryService()
    let db = Firestore.firestore()
    
    func checkWhetherUserCanTry(userId:String, completion:@escaping(Error?, Bool?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("trys").whereField("from", isEqualTo: myId).whereField("to", isEqualTo: userId).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                let documents = querySnapshot!.documents
                var count = 0
                if documents.count == 0 {
                    completion(nil, true)
                    return
                }
                for document in documents {
                    let data = document.data()
                    let tryInstance = Try(data: data)
                    let date = tryInstance.date
                    let today = Date()
                    if date.year() == today.year() && date.month() == today.month() && today.day() == date.day() {
                        count += 1
                    }
                }
                
                if count > 100 {
                    completion(nil, false)
                }else {
                    completion(nil, true)
                }
            }
        }
        
        
    }
    
    func tryToHaveAConversation(to:String){
        guard let from = Auth.auth().currentUser?.uid else { return }
        var tryDocument:DocumentReference?
        tryDocument = db.collection("trys").addDocument(data: [
            "from": from,
            "to": to,
            "date": FieldValue.serverTimestamp()
            ], completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    let tryId = tryDocument!.documentID
                    self.db.collection("users").document(from).updateData(["tryTo":FieldValue.arrayUnion([tryId])])
                    self.db.collection("users").document(to).updateData(["tryFrom":FieldValue.arrayUnion([tryId])])
                }
        })
        
    }
    
}
