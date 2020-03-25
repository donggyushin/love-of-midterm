//
//  ChatCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/25.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    // MARK: properties
    var chat:Chat?
    
    // MARK: Life cycles
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configures
    func configure(){
        backgroundColor = .tinderColor
    }
}
