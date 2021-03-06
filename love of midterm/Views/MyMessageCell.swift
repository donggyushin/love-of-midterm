//
//  MyMessageCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/27.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class MyMessageCell: UICollectionViewCell {
    
    // MARK: properties
    var message:Message? {
        didSet {
            configureMessage()
        }
    }
    var textBubbleViewWidthAnchor:NSLayoutConstraint?
    var timestampWidthAnchor:NSLayoutConstraint?
    
    // MARK: UIKits
    
    lazy var textBubbleView:UIView = {
        let view = UIView()
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .spaceGray
        }else {
            view.backgroundColor = .veryLightGray
        }
        
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var messageTextView:UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        if self.traitCollection.userInterfaceStyle == .dark {
            text.textColor = .white
        }else {
            text.textColor = .black
        }
        
        text.lineBreakMode = .byWordWrapping
        text.numberOfLines = 0
        return text
    }()
    
    lazy var timeStamp:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var yellowNumberLabel:UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont(name: "BMJUAOTF", size: 12)
        label.textColor = .systemYellow
        return label
    }()
    
    // MARK: Life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 테마가 변경될때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두운 테마일때
            textBubbleView.backgroundColor = .spaceGray
            messageTextView.textColor = .white
        }else {
            // 밝은 테마일때
            textBubbleView.backgroundColor = .veryLightGray
            messageTextView.textColor = .black
        }
    }
    
    // MARK: configures
    
    
    
    func configureMessage(){
        guard let message = self.message else { return }
        messageTextView.text = message.text
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
        
        
        if message.read == true {
            self.yellowNumberLabel.isHidden = true
            
        }else {
            self.yellowNumberLabel.isHidden = false
        }
        
        
        timeStamp.text = timestampText
    }
    
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        addSubview(textBubbleView)
        textBubbleView.translatesAutoresizingMaskIntoConstraints = false
        textBubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textBubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        textBubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textBubbleViewWidthAnchor = textBubbleView.widthAnchor.constraint(equalToConstant: 250)
        textBubbleViewWidthAnchor?.isActive = true
        
        addSubview(messageTextView)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 10).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: textBubbleView.rightAnchor, constant: -12).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: textBubbleView.leftAnchor, constant: 12).isActive = true
        
        addSubview(timeStamp)
        timeStamp.translatesAutoresizingMaskIntoConstraints = false
        timeStamp.rightAnchor.constraint(equalTo: textBubbleView.leftAnchor, constant: -4).isActive = true
        timeStamp.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        timestampWidthAnchor = timeStamp.widthAnchor.constraint(equalToConstant: 100)
        timestampWidthAnchor?.isActive = true
        
        addSubview(yellowNumberLabel)
        yellowNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        yellowNumberLabel.rightAnchor.constraint(equalTo: timeStamp.leftAnchor, constant: -4).isActive = true
        yellowNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
    }
    
}
