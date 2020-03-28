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
    
    var user:User?
    
    var userId:String? {
        didSet {
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
    }
    
    
    // MARK: UIKits
    
    lazy var profileImageView:UIImageView = {
        let profileView = UIImageView()
        profileView.contentMode = .scaleAspectFill
        profileView.backgroundColor = .systemGroupedBackground
        profileView.layer.cornerRadius = 8
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
    
    lazy var messageTextView:UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.font = UIFont(name: "BMJUAOTF", size: 16)
        text.backgroundColor = .clear
        return text
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
    
    // MARK: Selectors
    @objc func profileImageTapped(){
        delegate?.profileImageTapped(cell: self)
    }
    
    // MARK: configure
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        
        addSubview(profileImageView)
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(timeStamp)
    }
}
