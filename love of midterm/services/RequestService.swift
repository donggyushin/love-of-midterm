//
//  RequestService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct RequestService {
    static let shared = RequestService()
    
    let db = Firestore.firestore()
    
    func updateRequestCheckedStatus(id:String){
        db.collection("requests").document(id).updateData(["checked" : true])
    }
    
    func listenRequests(completion:@escaping(Error?, [Request]?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        var requests = [Request]()
        db.collection("requests").whereField("to", isEqualTo: myId).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                let documents = querySnapshot!.documents
                for document in documents {
                    let data = document.data()
                    let request = Request(data: data)
                    requests.append(request)
                }
                completion(nil, requests)
            }
        }
    }
    
    func fetchRequestForCounting(completion:@escaping(Error?, Int?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        db.collection("requests").whereField("to", isEqualTo: myId).whereField("checked", isEqualTo: false).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                let documents = querySnapshot!.documents
                completion(nil, documents.count)
            }
        }
    }
    
    func createRequest(to:String, completion:@escaping(Error?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        var tryCount = 0
        var requestReference:DocumentReference?
        db.collection("trys").whereField("from", isEqualTo: myId).whereField("to", isEqualTo: to).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
            }else {
                let documents = querySnapshot!.documents
                tryCount = documents.count
                requestReference = self.db.collection("requests").addDocument(data: [
                    "from": myId,
                    "to":to,
                    "tryCount":tryCount,
                    "checked":false,
                    "date":FieldValue.serverTimestamp(),
                    "dateInt": Int(Date().timeIntervalSince1970)
                ]) { (error) in
                    if let error = error {
                        completion(error)
                    }else {
                        let requestId = requestReference!.documentID
                       
                        self.db.collection("users").document(myId).updateData(["requestsISend" : FieldValue.arrayUnion([requestId])])
                        
                        self.db.collection("users").document(to).updateData(["requestsIReceived" : FieldValue.arrayUnion([requestId])])
                        self.db.collection("requests").document(requestId).updateData(["id" : requestId]) { (error) in
                            if let error = error {
                                completion(error)
                            }else {
                                completion(nil)
                            }
                        }
                    }
                }
            }
        }
        
    }
}
