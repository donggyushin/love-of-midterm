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
                            let data = querySnapshot!.data()!
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
        
        // 먼저 유저가 num 번째 test을 가지고 있는지 확인한 후 만약에 num 번째 test을 가지고 있다면 해당 test를 지워주고 시작한다.
        db.collection("users").document(userId).getDocument { (querySnapshot, error) in
            if let error = error {
                completion(error)
            }else {
                let data = querySnapshot!.data()!
                let testIds = data["testIds"] as? [String] ?? []
                for testId in testIds {
                    self.db.collection("tests").document(testId).getDocument { (querySnapshot, error) in
                        if let error = error {
                            completion(error)
                        }else {
                            let data = querySnapshot!.data()!
                            let testNum = data["num"] as? Int ?? 0
                            if num == testNum {
                                self.db.collection("users").document(userId).updateData(["testIds" : FieldValue.arrayRemove([testId])])
                                self.db.collection("tests").document(testId).delete()
                            }
                        }
                    }
                }
            }
        }
        
        
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
                    self.db.collection("users").document(userId).updateData(["testIds":FieldValue.arrayUnion([testId])])
                    self.db.collection("tests").document(testId).updateData(["id":testId]) { (error) in
                        if let error = error {
                            completion(error)
                        }else {
                            completion(nil)
                        }
                    }
                }
        }) // END posting test
    }
}
