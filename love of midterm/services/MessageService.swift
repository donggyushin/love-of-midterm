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
    
    func listenMessages(chatId:String, completion:@escaping(Error?, [Message]?) -> Void){
        db.collection("messages").whereField("chatId", isEqualTo: chatId).order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                
                var messages = [Message]()
                // 추가되는 데이터들만 확인하기
                
                querySnapshot!.documentChanges.forEach { (diff) in
                    if (diff.type == .added){
                        let data = diff.document.data()
                        let message = Message(data: data)
                        print("추가된 메시지: \(message)")
                        messages.append(message)
                    }
                }
                completion(nil, messages)
                
                
            }
        }
    }
    
    func postMessage(chatId:String, sender:String, text:String, completion:@escaping(Error?) -> Void){
        var messageReference:DocumentReference?
        
        db.collection("chats").document(chatId).updateData(["lastMessage" : text, "updatedAt": FieldValue.serverTimestamp()])
        
        messageReference = db.collection("messages").addDocument(data: [
            "sender":sender,
            "type":"TEXT",
            "chatId":chatId,
            "text":text,
            "read":false,
            "createdAt": FieldValue.serverTimestamp()
        ]) { (error) in
            if let error = error {
                completion(error)
            }else {
                let messageId = messageReference!.documentID
                self.db.collection("messages").document(messageId).updateData(["id":messageId]) { (error) in
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
