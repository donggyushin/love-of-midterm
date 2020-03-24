//
//  DenyRequestCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/24.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

class DenyRequestCell: UICollectionViewCell {
    
    // MARK: properties
    var request:Request? {
        didSet {
            fetchUser()
            configureRequest()
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
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.layer.cornerRadius = 25
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGroupedBackground
        return iv
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        return label
    }()
    
    lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.text = "님이 대화를 거절하셨습니다."
        label.textColor = .lightGray
        label.font = UIFont(name: "BMJUAOTF", size: 15)
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
    
    // MARK: Selectors
    
    @objc func tapped(){
        guard let request = request else { return }
        if request.checked == false {
            RequestService.shared.updateRequestCheckedStatus(id: request.id)
        }
    }
    
    // MARK: APIs
    
    func fetchUser(){
        guard let request = request else { return }
        UserService.shared.fetchUserWithId(id: request.from) { (error, user) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.user = user!
            }
        }
    }
    
    // MARK: configures
    
    func configureRequest(){
        guard let request = request else { return }
        if request.checked == true {
            backgroundColor = .systemGroupedBackground
        }
    }
    
    func configureUser(){
        guard let user = self.user else { return }
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        usernameLabel.text = user.username
    }
    
    func configure(){
        configureUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    func configureUI(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 4).isActive = true
        
    }
}
