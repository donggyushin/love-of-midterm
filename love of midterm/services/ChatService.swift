//
//  ChatService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/25.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct ChatService {
    static let shared = ChatService()
    
    let db = Firestore.firestore()
    
    func listenChats(completion:@escaping(Error?, [Chat]?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        db.collection("chats").whereField("users", arrayContains: myId).order(by: "updatedAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                var chats = [Chat]()
                let documents = querySnapshot!.documents
                for document in documents {
                    let data = document.data()
                    let chat = Chat(data: data)
                    chats.append(chat)
                }
                completion(nil, chats)
            }
        }
    }
    
    func createNewChat(userId:String, completion:@escaping(Error?, Chat?) -> Void){
        
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        var chatReference:DocumentReference?
        
        chatReference = db.collection("chats").addDocument(data: [
            "users":[myId, userId],
            "createdAt":FieldValue.serverTimestamp(),
            "updatedAt":FieldValue.serverTimestamp(),
            "lastMessage":""
            ], completion: { (error) in
                if let error = error {
                    completion(error, nil)
                }else {
                    let chatId = chatReference!.documentID
                    
                    self.db.collection("users").document(myId).updateData(["chatIds" : FieldValue.arrayUnion([chatId])])
                    self.db.collection("users").document(userId).updateData(["chatIds" : FieldValue.arrayUnion([chatId])])
                    
                    self.db.collection("chats").document(chatId).updateData(["id" : chatId]) { (error) in
                        if let error = error {
                            completion(error, nil)
                        }else {
                            chatReference!.getDocument { (querySnapshot, error) in
                                if let error = error {
                                    completion(error, nil)
                                }else {
                                    guard let data = querySnapshot!.data() else { return }
                                    let chat = Chat(data: data)
                                    completion(nil, chat)
                                }
                            }
                            
                        }
                    }
                }
        })
    }
}
