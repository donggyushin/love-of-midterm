//
//  OtherMessageCellTypeTwo.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/28.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class OtherMessageCellTypeTwo: UICollectionViewCell {
    
    // MARK: UIKits
    
    lazy var textBubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var messageTextView:UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont(name: "BMJUAOTF", size: 16)
        tv.backgroundColor = .clear
        return tv
    }()
    
    // MARK: Life cycles
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configure
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        addSubview(textBubbleView)
        addSubview(messageTextView)
    }
}
