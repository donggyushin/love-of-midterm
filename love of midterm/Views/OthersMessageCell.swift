//
//  OthersMessageCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/27.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

protocol OthersMessageCellDelegate:class {
    func profileImageTapped(cell:OthersMessageCell)
}

class OthersMessageCell: UICollectionViewCell {
    
    // MARK: properties
    
    weak var delegate:OthersMessageCellDelegate?
    
    
    
    var message:Message? {
        didSet {
            configureMessage()
        }
    }
    
    var user:User?
    
    var userId:String? {
        didSet {
            fetchUser()
        }
    }
    
    var textBubbleViewWidthAnchor:NSLayoutConstraint?
    var timestampeWidthAnchor:NSLayoutConstraint?
    
    
    // MARK: UIKits
    
    lazy var profileImageView:UIImageView = {
        let profileView = UIImageView()
        profileView.contentMode = .scaleAspectFill
        profileView.backgroundColor = .systemGroupedBackground
        profileView.layer.cornerRadius = 10
        profileView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tap)
        return profileView
    }()
    
    lazy var textBubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var messageTextView:UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "BMJUAOTF", size: 16)
        text.lineBreakMode = .byWordWrapping
        text.numberOfLines = 0 
        return text
    }()
    
    lazy var timeStamp:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 12)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var yellowNumberLabel:UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.text = "1"
        label.font = UIFont(name: "BMJUAOTF", size: 12)
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
    
    // MARK: Selectors
    @objc func profileImageTapped(){
        delegate?.profileImageTapped(cell: self)
    }
    
    // MARK: APIs
    func fetchUser(){
        guard let userId = self.userId else { return }
        UserService.shared.fetchUserWithId(id: userId) { (error, user) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.user = user!
                if let url = URL(string: user!.profileImageUrl) {
                    self.profileImageView.sd_setImage(with: url, completed: nil)
                }
            }
        }
    }
    
    // MARK: configure
    func configureMessage(){
        guard let message = self.message else { return }
        self.messageTextView.text = message.text
        let calendar = Calendar.current
        var timestampText = ""
        let date = message.createdAt
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        if hour == 12 {
            timestampText = "오후 12시 \(minutes)분"
        }else if hour > 12 {
            timestampText = "오후 \(hour - 12)시 \(minutes)분"
        }else {
            timestampText = "오전 \(hour)시 \(minutes)분"
        }
        
        MessageService.shared.readMessage(messageId: message.id)
        
        
        self.yellowNumberLabel.isHidden = true
        
        timeStamp.text = timestampText
    }
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(textBubbleView)
        textBubbleView.translatesAutoresizingMaskIntoConstraints = false
        textBubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textBubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 7).isActive = true
        textBubbleViewWidthAnchor = textBubbleView.widthAnchor.constraint(equalToConstant: 250)
        textBubbleViewWidthAnchor?.isActive = true
        textBubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(messageTextView)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.leftAnchor.constraint(equalTo: textBubbleView.leftAnchor, constant: 7).isActive = true
        messageTextView.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 10).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: textBubbleView.rightAnchor, constant: -7).isActive = true
        
        
        addSubview(timeStamp)
        timeStamp.translatesAutoresizingMaskIntoConstraints = false
        timeStamp.leftAnchor.constraint(equalTo: textBubbleView.rightAnchor, constant: 2).isActive = true
        timeStamp.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        timestampeWidthAnchor = timeStamp.widthAnchor.constraint(equalToConstant: 75)
        timestampeWidthAnchor?.isActive = true 
        
        addSubview(yellowNumberLabel)
        yellowNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        yellowNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        yellowNumberLabel.leftAnchor.constraint(equalTo: timeStamp.rightAnchor, constant: 0).isActive = true
        
        
    }
}
