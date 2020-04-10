//
//  TestService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/18.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct TestService {
    static let shared = TestService()
    let db = Firestore.firestore()
    
    
    func fetchTestWithNumAndUserId(userId:String, num:Int, completion:@escaping(Error?, Test?) -> Void){
        db.collection("users").document(userId).getDocument { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let user = User(data: data)
                
                let testIds = user.testIds
                
                for testId in testIds {
                    self.db.collection("tests").document(testId).getDocument { (querySnapshot, error) in
                        if let error = error {
                            completion(error, nil)
                        }else {
                            guard let data = querySnapshot!.data() else { return }
                            let test = Test(data: data)
                            if test.num == num {
                                completion(nil, test)
                                return
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func fetchTestWithNum(num:Int, completion:@escaping(Error?,Test?) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).getDocument { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                let data = querySnapshot!.data()!
                let testIds = data["testIds"] as? [String] ?? []
                
                for testId in testIds {
                    self.db.collection("tests").document(testId).getDocument { (querySnapshot, error) in
                        if let error = error {
                            completion(error, nil)
                        }else {
                            guard let data = querySnapshot!.data() else { return }
                            
                            let testNum = data["num"] as? Int ?? 0
                            if testNum == num {
                                let test = Test(data: data)
                                completion(nil, test)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func postNewTest(num:Int, title:String, questionOne:String, questionTwo:String, questionThree:String, questionFour:String, answer:Int, completion:@escaping(Error?) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        var testRef:DocumentReference?
        
        
        // START posting test
        testRef = db.collection("tests").addDocument(data: [
            "num":num,
            "title":title,
            "questionOne":questionOne,
            "questionTwo":questionTwo,
            "questionThree":questionThree,
            "questionFour":questionFour,
            "answer":answer,
            "userId": userId
            ], completion: { (error) in
                if let error = error {
                    completion(error)
                }else {
                    let testId = testRef!.documentID
                    
                    
                    self.db.collection("tests").document(testId).updateData(["id": testId]) { (error) in
                        if let error = error {
                            completion(error)
                        }else {
                            self.db.collection("users").document(userId).updateData(["testIds":FieldValue.arrayUnion([testId])]) { (error) in
                                if let error = error {
                                    completion(error)
                                }else {
                                    
                                    completion(nil)
                                    
                                    print("after completion")
                                    
                                    self.db.collection("tests").whereField("userId", isEqualTo: userId).getDocuments { (querySnapshot, error) in
                                        if let error = error {
                                            completion(error)
                                        }else {
                                            let documents = querySnapshot!.documents
                                            for document in documents {
                                                let data = document.data()
                                                guard let documentId = data["id"] as? String else { return }
                                                guard let documentNum = data["num"] as? Int else { return }
                                                
                                                if num == documentNum && documentId != testId {
                                                    self.db.collection("tests").document(documentId).delete()
                                                    self.db.collection("users").document(userId).updateData(["testIds" : FieldValue.arrayRemove([documentId])])
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                    
                }
        }) // END posting test
    }
}
