//
//  SideMenuViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/17.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

class SideMenuViewController: UIViewController {
    
    
    // MARK
    lazy var logoutButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var editProfileButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("프로필 변경", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        return button
    }()
    
    // MARK: life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Selectors
    
    @objc func logoutTapped(){
        dismiss(animated: true, completion: nil)
        try! Auth.auth().signOut()
        RootViewController.rootViewController.logoutFunction()
    }
    
    // MARK: configures
    
    func configure(){
        view.backgroundColor = .spaceGray
        navigationController?.navigationBar.barTintColor = .spaceGray
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        configureUI()
    }
    
    func configureUI(){
        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        editProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }

}
