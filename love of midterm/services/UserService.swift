//
//  UserService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct UserService {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    static let shared = UserService()
    
    func fetchUsers(completion:@escaping(Error?, [User]?) -> Void){
        var users = [User]()
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error, nil)
            }else {
                let documents = querySnapshot!.documents
                for document in documents {
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                }
                completion(nil, users)
            }
        }
    }
    
    func postBio(bio:String, completion:@escaping(Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).updateData([
            "bio":bio
        ], completion: completion)
    }
    
    func fetchUser(completion:@escaping(User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = querySnapshot!.data() else { return }
            let user = User(data: data)
            
            completion(user)
        }
    }
    
    func loginUser(email:String, password:String, completion:@escaping(Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error)
            }else {
                completion(nil)
            }
        }
    }
    
    func requestToNewUser(email:String, password:String, profileImage:UIImage, username:String, gender:String,
                          birthdayDateValue:Date, addressValue:Address,
                          completion:@escaping(Error?, String?) -> Void){
        let profileImageUidString = UUID().uuidString
        let profileImageRef = storage.reference().child("profile_images").child("\(profileImageUidString).jpg")
        let dataOp:Data? = profileImage.jpegData(compressionQuality: 1)
        guard let data = dataOp else {
            completion(nil, "이용에 불편을 끼쳐드려 죄송합니다. 프로필 이미지를 서버에 업로드하는데 실패하였습니다. 개발자에게 에러에 관해서 알려주세요")
            return
        }
        let uploadTask = profileImageRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error, "")
                return
            }
            profileImageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(error, "")
                    return
                }
                let downloadUrl = url!.absoluteString
                
                // Start create user
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    guard let result = result else {
                        completion(error!, "")
                        return
                    }
                    // 유저 회원가입 성공.
                    let userUid = result.user.uid
                    
                    
                    var addressRef:DocumentReference?
                    addressRef = self.db.collection("addresses").addDocument(data: [
                        "title":addressValue.title,
                        "link":addressValue.link,
                        "userId":userUid,
                        "category":addressValue.category,
                        "description":addressValue.description,
                        "telephone":addressValue.telephone,
                        "address":addressValue.address,
                        "roadAddress":addressValue.roadAddress,
                        "mapx":addressValue.mapx,
                        "mapy":addressValue.mapy
                    ]) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(error, nil)
                        }else {
                            let addressId = addressRef!.documentID
                            self.db.collection("addresses").document(addressId).updateData(["id":addressId])
                            
                            self.db.collection("users").document(userUid).setData([
                                "id": userUid,
                                "email": email,
                                "password": password,
                                "profileImageUrl": downloadUrl,
                                "username": username,
                                "profileImageReference": "profile_images/\(profileImageUidString).jpg",
                                "birthday":birthdayDateValue,
                                "gender":gender,
                                "addressId":addressId
                            ]) { (error) in
                                if let error = error {
                                    completion(error, nil)
                                }
                                print("성공적으로 회원가입을 마쳤습니다. ")
                                completion(nil, nil)
                            }
                        }
                    }
                }
            }
        } // End of upload task
        uploadTask.resume()
    }
}
