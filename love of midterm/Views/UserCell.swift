//
//  UserCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell {
    
    // MARK: properties
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    var me:User? {
        didSet {
            calculateDistance()
        }
    }
    
    // MARK: UIKits
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGroupedBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.layer.cornerRadius = 25
        
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.tinderColor.cgColor
        
        
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
    
    lazy var genderMark:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "female")
        iv.image = iv.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iv.tintColor = UIColor.tinderColor
        
        return iv
    }()
    
    lazy var distanceLabel:UILabel = {
        let label = UILabel()
        label.text = "?? km"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        
        return label
    }()
    
    lazy var bioTextLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        
        
        return label
    }()
    
    // MARK: life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두울 때
            backgroundColor = .black
            usernameLabel.textColor = .white
            distanceLabel.textColor = .white
            bioTextLabel.textColor = .white
        }else {
            // 밝을 때
            backgroundColor = .white
            usernameLabel.textColor = .black
            distanceLabel.textColor = .black
            bioTextLabel.textColor = .black
        }
    }
    
    // MARK: helpers
    
    func calculateDistance(){
        guard let user = user else { return }
        guard let me = me else { return }
        
        AddressService.shared.calculateTwoDistance(id1: user.addressId, id2: me.addressId) { (error, distance) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.distanceLabel.text = "\(distance!) km"
            }
        }
        
    }
    
    
    
    // MARK: configures
    
    func configureUser(){
        guard let user = user else { return }
        if let url = URL(string: user.profileImageUrl) {
            self.profileImageView.sd_setImage(with: url, completed: nil)
        }
        usernameLabel.text = user.username
        bioTextLabel.text = user.bio
        
        if user.gender == "female" {
            genderMark.image = #imageLiteral(resourceName: "female")
            genderMark.image = genderMark.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            genderMark.tintColor = .tinderColor
            profileImageView.layer.borderColor = UIColor.tinderColor.cgColor
        }else {
            genderMark.image = #imageLiteral(resourceName: "male")
            genderMark.image = genderMark.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            genderMark.tintColor = .facebookBlue
            profileImageView.layer.borderColor = UIColor.facebookBlue.cgColor
        }
    }
    
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            backgroundColor = .black
        }else {
            backgroundColor = .white
        }
        
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        
        addSubview(genderMark)
        genderMark.translatesAutoresizingMaskIntoConstraints = false
        genderMark.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        genderMark.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 5).isActive = true
        
        addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        
        addSubview(bioTextLabel)
        bioTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bioTextLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 7).isActive = true
        bioTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        bioTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
    }
    
}
