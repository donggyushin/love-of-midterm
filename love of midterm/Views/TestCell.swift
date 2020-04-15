//
//  TestCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/10.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class TestCell: UICollectionViewCell {
    
    // MARK: Properties
    var test:Test? {
        didSet {
            setTest()
        }
    }
    
    // MARK: UIKits
    
    lazy var testNumberLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        label.text = ""
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var testTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
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
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두울 때
            testNumberLabel.textColor = .white
            testTitleLabel.textColor = .white
        }else {
            // 밝을때
            testNumberLabel.textColor = .black
            testTitleLabel.textColor = .black
        }
    }
    
    // MARK: helpers
    func setTest(){
        guard let test = test else { return }
        testNumberLabel.text = "\(test.num)번 문제"
        testTitleLabel.text = test.title
    }
    
    // MARK: configures
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        addSubview(testNumberLabel)
        testNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        testNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        testNumberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        addSubview(testTitleLabel)
        testTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        testTitleLabel.topAnchor.constraint(equalTo: testNumberLabel.bottomAnchor, constant: 12).isActive = true
        testTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        testTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
    }
    
}
