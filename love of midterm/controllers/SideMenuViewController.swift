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
        button.addTarget(self, action: #selector(changeProfileButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var changeTests:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("문제 변경", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.addTarget(self, action: #selector(changeTestsButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var seeTests:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("문제 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.addTarget(self, action: #selector(seeTestsButtonTapped), for: UIControl.Event.touchUpInside)
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
    
    @objc func changeProfileButtonTapped(){
        print("changeProfileButtonTapped")
    }
    
    @objc func changeTestsButtonTapped(){
        print("changeTestsButtonTapped")
    }
    
    @objc func seeTestsButtonTapped(){
        print("seeTestsButtonTapped")
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
        
        
        view.addSubview(changeTests)
        changeTests.translatesAutoresizingMaskIntoConstraints = false
        changeTests.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20).isActive = true
        changeTests.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        changeTests.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        
        view.addSubview(seeTests)
        seeTests.translatesAutoresizingMaskIntoConstraints = false
        seeTests.topAnchor.constraint(equalTo: changeTests.bottomAnchor, constant: 20).isActive = true
        seeTests.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        seeTests.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topAnchor.constraint(equalTo: seeTests.bottomAnchor, constant: 20).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }

}
