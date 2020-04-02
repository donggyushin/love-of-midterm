//
//  ChangeProfileController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/02.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

class ChangeProfileController: UIViewController {
    
    // MARK: Properties
    
    // MARK: UIKits
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("프로필", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.addTarget(self, action: #selector(backButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
    lazy var profileView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .veryLightGray
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    lazy var nameIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        iv.image = iv.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iv.tintColor = .tinderColor
        return iv
    }()
    
    lazy var usernameTextField:UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "BMJUAOTF", size: 16)
        tf.textColor = .tinderColor
        tf.text = "신동규"
        tf.autocorrectionType = .no
        tf.placeholder = "사용자들에게 보여지게 됩니다"
        return tf
    }()
    
    lazy var dividerUnderUsername:UIView = {
        let view = UIView()
        view.backgroundColor = .tinderColor
        return view
    }()

    // MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    // MARK: Selectors
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: configures
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func configure(){
        hideKeyboardWhenTappedAround()
        configureUI()
        configureNavigationBar()
    }
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        guard let font = UIFont(name: "BMJUAOTF", size: 16) else { return }
        
        self.navigationItem.title = "프로필 변경"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:font]
    }
    
    func configureUI(){
        self.view.backgroundColor = .white
        
        view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profileView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(nameIcon)
        nameIcon.translatesAutoresizingMaskIntoConstraints = false
        nameIcon.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 20).isActive = true
        nameIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        nameIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 27).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: nameIcon.rightAnchor, constant: 10).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(dividerUnderUsername)
        dividerUnderUsername.translatesAutoresizingMaskIntoConstraints = false
        dividerUnderUsername.topAnchor.constraint(equalTo: nameIcon.bottomAnchor, constant: 2).isActive = true
        dividerUnderUsername.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22).isActive = true
        dividerUnderUsername.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        dividerUnderUsername.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    

}


extension ChangeProfileController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true 
    }
}
