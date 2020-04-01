//
//  LogoSample.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/01.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class LogoSample: UIViewController {
    
    // MARK: UIKits

    lazy var midtermLabel:UILabel = {
        let label = UILabel()
        label.text = "중간의"
        label.font = UIFont(name: "BMJUAOTF", size: 43)
        label.textColor = .white
        return label
    }()
    
    lazy var loveLabel:UILabel = {
        let label = UILabel()
        label.text = "연애"
        label.font = UIFont(name: "BMJUAOTF", size: 43)
        label.textColor = .white
        return label
    }()

    
    // MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Configures
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = .tinderColor
        view.addSubview(midtermLabel)
        midtermLabel.translatesAutoresizingMaskIntoConstraints = false
        midtermLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        midtermLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        
        view.addSubview(loveLabel)
        loveLabel.translatesAutoresizingMaskIntoConstraints = false
        loveLabel.topAnchor.constraint(equalTo: midtermLabel.bottomAnchor, constant: 8).isActive = true
        loveLabel.leftAnchor.constraint(equalTo: midtermLabel.leftAnchor, constant: 60).isActive = true
    }
    

}
