//
//  RequestCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

protocol RequestCellDelegate:class {
    func goToChoiceController(cell:RequestCell)
}

class RequestCell: UICollectionViewCell {
    
    // MARK: Properties
    weak var delegate:RequestCellDelegate?
    
    var request:Request? {
        didSet {
            fetchUser()
        }
    }
    
    var user:User? {
        didSet {
            configureUserAndRequest()
            addTapGestureOnTheCell()
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
    
    lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let attribute = [NSAttributedString.Key.font: UIFont(name: "BMJUAOTF", size: 15)]
        let string = NSMutableAttributedString(string: "", attributes: attribute as [NSAttributedString.Key : Any])
        let attrString = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont(name: "BMJUAOTF", size: 15) as Any,
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ])
        string.append(attrString)
        label.attributedText = string
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
    
    // MARK: helpers
    func addTapGestureOnTheCell(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    // MARK: selectors
    @objc func cellTapped(){
        delegate?.goToChoiceController(cell: self)
    }
    
    // MARK: configure
    
    func configureUserAndRequest(){
        guard let user = user else { return }
        guard let request = request else { return }
        
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        
        let attribute = [NSAttributedString.Key.font: UIFont(name: "BMJUAOTF", size: 16)]
        let string = NSMutableAttributedString(string: "\(user.username) ", attributes: attribute as [NSAttributedString.Key : Any])
        let attrString = NSAttributedString(string: "님이 \(request.tryCount)번의 시도 후에 시험을 통과하였습니다.", attributes: [NSAttributedString.Key.font : UIFont(name: "BMJUAOTF", size: 14) as Any])
        string.append(attrString)
        contentLabel.attributedText = string
        
        if request.checked == true {
            self.backgroundColor = .systemGroupedBackground
        }else {
            self.backgroundColor = .white
        }
        
    }
    
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        
        
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 36).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        contentLabel.rightAnchor.constraint(equalTo:rightAnchor, constant: -30).isActive = true
        
        
    }
    
}
