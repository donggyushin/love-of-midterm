//
//  MyMessageCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/27.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class MyMessageCell: UICollectionViewCell {
    
    // MARK: UIKits
    
    lazy var textBubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = .facebookBlue
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var messageTextView:UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.font = UIFont(name: "BMJUAOTF", size: 16)
        text.textColor = .white
        text.backgroundColor = .clear
        return text
    }()
    
    // MARK: Life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configures
    
   
    
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        

    }
    
}
