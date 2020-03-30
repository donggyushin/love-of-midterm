//
//  MessageService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/26.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct MessageService {
    static let shared = MessageService()
    
    let db = Firestore.firestore()
    
    func readMessage(messageId:String){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        db.collection("messages").document(messageId).updateData(["read":true])
        db.collection("users").document(myId).updateData(["unreadMessages" : FieldValue.arrayRemove([messageId])])
    }
    
    func listenUnreadMessagesWithChat(chat:Chat, completion:@escaping(Error?, Int?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        let othersIds = chat.users.filter { (id) -> Bool in
            if id == myId {
                return false
            }else {
                return true
            }
        }
        
        let otherId = othersIds[0]
        
        db.collection("messages").whereField("chatId", isEqualTo: chat.id).whereField("sender", isEqualTo: otherId).whereField("read", isEqualTo: false).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                let documents = querySnapshot!.documents
                completion(nil, documents.count)
            }
        }
    }
    
    func listenUnreadMessagesCount(completion:@escaping(Error?, Int?) -> Void){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myId).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let user = User(data: data)
                completion(nil, user.unreadMessages.count)
            }
        }
    }
    
    func listenMessages(chatId:String, completion:@escaping(Error?, Message?, Message?) -> Void){
        
        db.collection("messages").whereField("chatId", isEqualTo: chatId).order(by: "createdAt", descending: false).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil, nil)
            }else {
                
                
                // 추가되는 데이터들만 확인하기
                
                querySnapshot!.documentChanges.forEach { (diff) in
                    if (diff.type == .added){
                        let data = diff.document.data()
                        let message = Message(data: data)
                        completion(nil, message, nil)
                    } else if(diff.type == .modified){
                        let data = diff.document.data()
                        let message = Message(data: data)
                        completion(nil, nil, message)
                    }
                }
                
                
            }
        }
    }
    
    func postMessage(chatId:String, sender:String, text:String, receiver:String, completion:@escaping(Error?) -> Void){
        
        db.collection("chats").document(chatId).updateData(["lastMessage" : text, "updatedAt": FieldValue.serverTimestamp()])
        
        let uuid = UUID().uuidString
        
        db.collection("messages").document(uuid).setData([
        "sender":sender,
        "type":"TEXT",
        "chatId":chatId,
        "text":text,
        "read":false,
        "createdAt": FieldValue.serverTimestamp(),
        "id":uuid
        ]) { (error) in
            if let error = error {
                completion(error)
            }else {
                completion(nil)
            }
        }
        db.collection("users").document(receiver).updateData(["unreadMessages" : FieldValue.arrayUnion([uuid])])

    }
}
