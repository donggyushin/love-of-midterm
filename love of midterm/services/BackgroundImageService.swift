//
//  BackgroundImageService.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/14.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct BackgroundImageService {
    static let shared = BackgroundImageService()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    func deleteBackgroundImage(user:User, backgroundImage:BackgroundImage, completion:@escaping(Error?) -> Void){
        // 유저의 백그라운드 이미지에서 이미지를 지운다.
        db.collection("users").document(user.id).updateData([
            "backgroundImages":FieldValue.arrayRemove([backgroundImage.id])
        ])
        
        // 백그라운드 이미지 파일을 삭제한다.
        let backgroundImageStorageRef = storage.child(backgroundImage.referenceId)
        
        backgroundImageStorageRef.delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // 데이터베이스 백그라운드 이미지를 삭제한다.
        db.collection("backgroundImages").document(backgroundImage.id).delete { (error) in
            if let error = error {
                completion(error)
            }else {
                completion(nil)
            }
        }
    }
    
    func fetchBackgroundImage(user:User, completion:@escaping([BackgroundImage]?, String?) -> Void){
        var backgroundImages = [BackgroundImage]()
        for backgroundImageId in user.backgroundImages {
            self.db.collection("backgroundImages").document(backgroundImageId).getDocument { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error.localizedDescription)
                }else {
                    let data = querySnapshot!.data()!
                    let backgroundImage = BackgroundImage(data: data)
                    backgroundImages.append(backgroundImage)
                    completion(backgroundImages, nil)
                }
            }
        }
    }
    
    
    func postBackgroundImage(image:UIImage, completion:@escaping(Error?, String?, BackgroundImage?) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        
        let uuid = UUID().uuidString
        let backgroundImageRef = storage.child("background_images").child("\(uuid).jpg")
        let uploadTask = backgroundImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error, nil, nil)
            }else {
                backgroundImageRef.downloadURL { (url, error) in
                    if let error = error {
                        completion(error, nil, nil)
                        return
                    }
                    let downloadUrl = url!.absoluteString
                    var backgroundImageRef:DocumentReference?
                    backgroundImageRef = self.db.collection("backgroundImages").addDocument(data: [
                        "userId":userId,
                        "downloadUrl": downloadUrl,
                        "referenceId": "background_images/\(uuid).jpg"
                        ], completion: { (error) in
                            if let error = error {
                                completion(error, nil, nil)
                            }else {
                                let backgroundImageUid = backgroundImageRef!.documentID
                                self.db.collection("users").document(userId).updateData([
                                    "backgroundImages":FieldValue.arrayUnion([backgroundImageUid])
                                ])
                                self.db.collection("backgroundImages").document(backgroundImageUid).updateData([
                                    "id": backgroundImageUid
                                ]) { (error) in
                                    if let error = error {
                                        completion(error, nil, nil)
                                        return
                                    }
                                    let backgroumdImage = BackgroundImage(downloadUrl: downloadUrl, id: backgroundImageUid, referenceId: "background_images/\(uuid).jpg", userId: userId)
                                    completion(nil, nil, backgroumdImage)
                                }
                            }
                    })
                }
            }
        }
        uploadTask.resume()
    }
}
