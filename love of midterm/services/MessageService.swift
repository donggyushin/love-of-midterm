//
//  MessageService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/26.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase
import OneSignal

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
    
    func getUnreadMessagesCount(userId:String, completion:@escaping(Error?, Int?) -> Void){
        db.collection("users").document(userId).getDocument { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let user = User(data: data)
                completion(nil, user.unreadMessages.count)
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
    
    func fetchOldMessages(chatId:String, lastMessage:Message, completion:@escaping(Error?, [Message]?) -> Void) {
        db.collection("messages").whereField("chatId", isEqualTo: chatId).order(by: "createdAt", descending: true).start(at: [lastMessage.createdAt]).limit(to: 20).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                var messages = [Message]()
                var i = 0
                for document in querySnapshot!.documents {
                    if i == 0 {
                        i += 1
                        
                    }else {
                        let data = document.data()
                        let message = Message(data: data)
                        messages.insert(message, at: 0)
                    }
                    
                }
                completion(nil, messages)
            }
        }
    }
    
    func listenMessages(chatId:String, completion:@escaping(Error?, Message?, Message?) -> Void){
        
        db.collection("messages").whereField("chatId", isEqualTo: chatId).order(by: "createdAt", descending: false).limit(toLast: 50).addSnapshotListener { (querySnapshot, error) in
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
    
    func postMessage(chatId:String, sender:User, text:String, receiver:User, completion:@escaping(Error?) -> Void){
        db.collection("chats").document(chatId).updateData(["lastMessage" : text, "updatedAt": FieldValue.serverTimestamp()])
        let uuid = UUID().uuidString
        db.collection("messages").document(uuid).setData([
            "sender":sender.id,
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
                
                if receiver.playerId != "" {
                    
                    
                    RequestService.shared.getRequestsCount(userId: receiver.id) { (error, unreadRequests) in
                        
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            MessageService.shared.getUnreadMessagesCount(userId: receiver.id) { (error, unreadMessages) in
                                
                                if let error = error {
                                    print(error.localizedDescription)
                                }else {
                                    OneSignal.postNotification([
                                    "contents" : ["en": text, "kr" : text],
                                    "subtitle": ["en": sender.username, "kr" : sender.username],
                                    "include_player_ids": [receiver.playerId],
                                    "ios_badgeType" : "SetTo",
                                    "ios_badgeCount" : unreadMessages! + unreadRequests!
                                    ], onSuccess: nil) { (error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                completion(nil)
            }
        }
        db.collection("users").document(receiver.id).updateData(["unreadMessages" : FieldValue.arrayUnion([uuid])])

    }
}
