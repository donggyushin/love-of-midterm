//
//  RequestService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase
import OneSignal

struct RequestService {
    static let shared = RequestService()
    
    let db = Firestore.firestore()
    
    func updateRequestCheckedStatus(id:String){
        db.collection("requests").document(id).updateData(["checked" : true])
    }
    
    func listenRequests(completion:@escaping(Error?, [Request]?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("requests").whereField("to", isEqualTo: myId).order(by: "date", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                var requests = [Request]()
                for document in querySnapshot!.documents {
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
    
    func createDenyRequest(to:String, completion:@escaping(Error?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        var requestReference:DocumentReference?
        
        requestReference = db.collection("requests").addDocument(data: [
            "from":myId,
            "to":to,
            "tryCount":0,
            "checked":false,
            "date":FieldValue.serverTimestamp(),
            "dateInt": Int(Date().timeIntervalSince1970),
            "type": "DENY"
        ]) { (error) in
            if let error = error {
                completion(error)
            }else {
                let requestId = requestReference!.documentID
                self.db.collection("requests").document(requestId).updateData(["id" : requestId]) { (error) in
                    if let error = error {
                        completion(error)
                    }else {
                        completion(nil)
                    }
                }
                self.db.collection("users").document(myId).updateData(["requestsISend" : FieldValue.arrayUnion([requestId])])
                
                self.db.collection("users").document(to).updateData(["requestsIReceived" : FieldValue.arrayUnion([requestId])])
                
                
            }
        }
    }
    
    func createRequest(me:User,to:User, completion:@escaping(Error?) -> Void){
        
        var tryCount = 0
        var requestReference:DocumentReference?
        db.collection("trys").whereField("from", isEqualTo: me.id).whereField("to", isEqualTo: to.id).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
            }else {
                let documents = querySnapshot!.documents
                tryCount = documents.count
                requestReference = self.db.collection("requests").addDocument(data: [
                    "from": me.id,
                    "to":to.id,
                    "tryCount":tryCount,
                    "checked":false,
                    "date":FieldValue.serverTimestamp(),
                    "dateInt": Int(Date().timeIntervalSince1970),
                    "type": "PASS"
                ]) { (error) in
                    if let error = error {
                        completion(error)
                    }else {
                        let requestId = requestReference!.documentID
                       
                        self.db.collection("users").document(me.id).updateData(["requestsISend" : FieldValue.arrayUnion([requestId])])
                        
                        self.db.collection("users").document(to.id).updateData(["requestsIReceived" : FieldValue.arrayUnion([requestId])])
                        self.db.collection("requests").document(requestId).updateData(["id" : requestId]) { (error) in
                            if let error = error {
                                completion(error)
                            }else {
                                completion(nil)
                                if to.playerId != "" {
                                    OneSignal.postNotification([
                                        "contents" : ["en": "\(me.username)님이 \(tryCount)번 만에 시험을 모두 통과하였습니다!", "kr" : "\(me.username)님이 \(tryCount)번 만에 시험을 모두 통과하였습니다!"],
                                        "subtitle": ["en": "축하합니다!", "kr" : "축하합니다!"],
                                        "include_player_ids": [to.playerId],
                                        "ios_badgeType" : "Increase",
                                        "ios_badgeCount" : 1
                                    ])
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}
