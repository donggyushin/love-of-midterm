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
    
    func requestToNewUser(email:String, password:String, profileImage:UIImage, username:String, completion:@escaping(Error?, String?) -> Void){
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
                    self.db.collection("users").document(userUid).setData([
                        "id": userUid,
                        "email": email,
                        "password": password,
                        "profileImageUrl": downloadUrl,
                        "username": username,
                        "profileImageReference": "profile_images/\(profileImageUidString).jpg"
                    ]) { (error) in
                        if let error = error {
                            completion(error, "")
                        }
                        print("성공적으로 회원가입을 마쳤습니다. ")
                        completion(nil, nil)
                    }
                }
                
                
            }
        } // End of upload task
        uploadTask.resume()
    }
}
