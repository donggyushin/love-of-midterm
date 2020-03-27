//
//  OthersMessageCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/27.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

class OthersMessageCell: UICollectionViewCell {
    
    // MARK: properties
    
    var userId:String? {
        didSet {
            guard let userId = self.userId else { return }
            UserService.shared.fetchUserWithId(id: userId) { (error, user) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    if let url = URL(string: user!.profileImageUrl) {
                        self.profileImageView.sd_setImage(with: url, completed: nil)
                    }
                }
            }
        }
    }
    
    
    // MARK: UIKits
    
    lazy var profileImageView:UIImageView = {
        let profileView = UIImageView()
        profileView.contentMode = .scaleAspectFill
        profileView.backgroundColor = .systemGroupedBackground
        profileView.layer.cornerRadius = 8
        profileView.layer.masksToBounds = true
        return profileView
    }()
    
    lazy var textBubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var messageTextView:UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.font = UIFont(name: "BMJUAOTF", size: 16)
        text.backgroundColor = .clear
        return text
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
        
        addSubview(profileImageView)
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
    }
}
