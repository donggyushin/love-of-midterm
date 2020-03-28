//
//  ChatCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/25.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ChatCell: UICollectionViewCell {
    
    // MARK: properties
    var chat:Chat? {
        didSet {
            fetchUser()
            configureChat()
        }
    }
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    // MARK: UIKits
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.backgroundColor = .systemGroupedBackground
        return iv
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 16)
        return label
    }()
    
    lazy var lastMessageLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    lazy var timeStamp:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: Life cycles
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: APIs
    func fetchUser(){
        guard let chat = chat else { return }
        guard let myId = Auth.auth().currentUser?.uid else { return }
        var userIdImFinding:String?
        for userId in chat.users {
            if userId != myId {
                userIdImFinding = userId
            }
        }
        
        guard userIdImFinding != nil else { return }
        UserService.shared.fetchUserWithId(id: userIdImFinding!) { (error, user) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.user = user!
            }
        }
        
    }
    
    // MARK: configures
    func configure(){
        configureUI()
    }
    
    func configureChat(){
        guard let chat = self.chat else { return }
        let date = chat.updatedAt
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        if hour == 12 {
            timeStamp.text = "오후 12시 \(minutes)분"
        }else if hour > 12 {
            timeStamp.text = "오후 \(hour - 12)시 \(minutes)분"
        }else {
            timeStamp.text = "오전 \(hour)시 \(minutes)분"
        }
    }
    
    
    func configureUser(){
        guard let user = user else { return }
        guard let chat = chat else { return }
        
        usernameLabel.text = user.username
        
        if chat.lastMessage == "" {
            lastMessageLabel.text = "\(user.username)님과 대화를 시작해보세요"
        }else {
            lastMessageLabel.text = "\(chat.lastMessage)"
        }
        
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    func configureUI(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        
        addSubview(timeStamp)
        timeStamp.translatesAutoresizingMaskIntoConstraints = false
        timeStamp.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        addSubview(lastMessageLabel)
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4).isActive = true
        lastMessageLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        lastMessageLabel.rightAnchor.constraint(equalTo: timeStamp.leftAnchor, constant: 10).isActive = true
        
        
        
    }
}
