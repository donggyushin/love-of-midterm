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
            checkUnreadNumber()
        }
    }
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    var unreadNumberWidthAnchor:NSLayoutConstraint?
    
    // MARK: UIKits
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.backgroundColor = .veryLightGray
        return iv
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        
        return label
    }()
    
    lazy var genderMarker:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        return iv
    }()
    
    lazy var lastMessageLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .lightGray
        return label
    }()
    
    
    lazy var timeStamp:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    lazy var unreadNumberView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 6
        return view
    }()
    
    lazy var unreadNumberLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 12)
        label.textColor = .white
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
    
    // MARK: 테마 바뀔때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두운 테마일때
            usernameLabel.textColor = .white
        }else {
            // 밝은 테마일때
            usernameLabel.textColor = .black
        }
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
    
    func checkUnreadNumber(){
        guard let chat = self.chat else { return }
        MessageService.shared.listenUnreadMessagesWithChat(chat: chat) { (error, unreadMessageCount) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let unreadMessageCount = unreadMessageCount else { return }
                if unreadMessageCount == 0 {
                    self.unreadNumberView.isHidden = true
                    self.unreadNumberLabel.isHidden = true
                }else {
                    let unreadMessageCountString = String(unreadMessageCount)
                    guard let font = UIFont(name: "BMJUAOTF", size: 12) else { return }
                    let estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: unreadMessageCountString, width: 100, font: font)
                    
                    self.unreadNumberWidthAnchor?.constant = estimatedFrame.width + 7
                    self.unreadNumberLabel.text = unreadMessageCountString
                    self.unreadNumberView.isHidden = false
                    self.unreadNumberLabel.isHidden = false
                }
                
                
            }
        }
    }
    
    func configureChat(){
        guard let chat = self.chat else { return }
        let todayDate = Date()
        let date = chat.updatedAt
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        
        if todayDate.year() == date.year() && todayDate.month() == date.month() && todayDate.day() == date.day() {
            if hour == 12 {
                timeStamp.text = "오후 12시 \(minutes)분"
            }else if hour > 12 {
                timeStamp.text = "오후 \(hour - 12)시 \(minutes)분"
            }else {
                timeStamp.text = "오전 \(hour)시 \(minutes)분"
            }
        }else if todayDate.year() == date.year() {
            timeStamp.text = "\(date.month())월 \(date.day())일"
        }else {
            timeStamp.text = "\(date.year()). \(date.month()). \(date.day())."
        }
        
        if let timestampText = timeStamp.text {
            let font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
            let estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: timestampText, width: 200, font: font)
            self.timeStamp.widthAnchor.constraint(equalToConstant: estimatedFrame.width + 10).isActive = true
        }
        
    }
    
    
    func configureUser(){
        guard let user = user else { return }
        guard let chat = chat else { return }
        
        usernameLabel.text = user.username
        
        if user.gender == "male" {
            self.genderMarker.image = #imageLiteral(resourceName: "male")
            self.genderMarker.image = self.genderMarker.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.genderMarker.tintColor = .facebookBlue
        }else {
            self.genderMarker.image = #imageLiteral(resourceName: "female")
            self.genderMarker.image = self.genderMarker.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.genderMarker.tintColor = .tinderColor
        }
        
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
        
        addSubview(genderMarker)
        genderMarker.translatesAutoresizingMaskIntoConstraints = false
        genderMarker.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        genderMarker.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 6).isActive = true
        
        
        addSubview(timeStamp)
        timeStamp.translatesAutoresizingMaskIntoConstraints = false
        timeStamp.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        
        
        addSubview(lastMessageLabel)
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4).isActive = true
        lastMessageLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        lastMessageLabel.rightAnchor.constraint(equalTo: timeStamp.leftAnchor, constant: 10).isActive = true
        
        
        addSubview(unreadNumberView)
        unreadNumberView.translatesAutoresizingMaskIntoConstraints = false
        unreadNumberView.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 4).isActive = true
        unreadNumberView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        unreadNumberView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        unreadNumberWidthAnchor = unreadNumberView.widthAnchor.constraint(equalToConstant: 0)
        unreadNumberWidthAnchor?.isActive = true
        
        addSubview(unreadNumberLabel)
        unreadNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        unreadNumberLabel.centerXAnchor.constraint(equalTo: unreadNumberView.centerXAnchor).isActive = true
        unreadNumberLabel.centerYAnchor.constraint(equalTo: unreadNumberView.centerYAnchor).isActive = true
        
    }
}
