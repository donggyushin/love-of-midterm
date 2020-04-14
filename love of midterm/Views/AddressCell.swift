//
//  AddressCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/16.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class AddressCell: UICollectionViewCell {
    
    // MARK: properties
    
    var address:Address? {
        didSet {
            configureAddress()
        }
    }
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    
    lazy var categoryLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var loadAddressLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = .black
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
    
    // MARK: configure()
    
    func configureAddress(){
        guard let address = address else { return }
        let titleText = address.title.replacingLastOccurrenceOfString("<b>", with: "")
        let titleText2 = titleText.replacingLastOccurrenceOfString("</b>", with: " ")
        titleLabel.text = titleText2
        categoryLabel.text = address.category
        loadAddressLabel.text = address.roadAddress
    }
    
    func configure(){
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        
        addSubview(loadAddressLabel)
        loadAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        loadAddressLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        loadAddressLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 6).isActive = true 
        
    }
}
