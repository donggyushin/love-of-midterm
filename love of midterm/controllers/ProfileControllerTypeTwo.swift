//
//  ProfileControllerTypeTwo.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ProfileControllerTypeTwo: UIViewController {
    
    // MARK: UIKits
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화상대 찾기", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.setTitleColor(.tinderColor, for: .normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: configure
    func configure(){
        view.backgroundColor = .white
        configureNavigation()
    }
    
    func configureNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
}
