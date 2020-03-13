//
//  LoginController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: properties

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
    
    lazy var emailTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        let textField = UITextField()
        
        iconView.image = #imageLiteral(resourceName: "mail")
        iconView.tintColor = .white
        view.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.contentMode = .scaleAspectFill
        
        bottomLine.backgroundColor = .white
        view.addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "Email@gmail.com",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.font = UIFont(name: "BMJUAOTF", size: 17)
        textField.textColor = .white
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1).isActive = true
        textField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return view
    }()
    
    lazy var passwordTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        let textField = UITextField()
        
        iconView.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        iconView.tintColor = .white
        view.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.contentMode = .scaleAspectFill
        
        bottomLine.backgroundColor = .white
        view.addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textColor = .white
        view.addSubview(textField)
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: "BMJUAOTF", size: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 3).isActive = true
        textField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return view
    }()
    
    lazy var loginButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("LOGIN", for: UIControl.State.normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 20)
        return button
    }()
    
    lazy var textGoToSignUpView1:UIButton = {
        let label = UIButton()
        label.setTitle("아직 계정이 없으신가요?", for: .normal)
        label.setTitleColor(.white, for: .normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        label.addTarget(self, action: #selector(goToSignUpController), for: .touchUpInside)
        return label
    }()
    
    lazy var textGoToSignUpView2:UIButton = {
        let label = UIButton(type: UIButton.ButtonType.system)
        label.setTitle("회원가입", for: .normal)
        label.setTitleColor(.white, for: .normal)
        label.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        label.addTarget(self, action: #selector(goToSignUpController), for: .touchUpInside)
        return label
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: selectors
    
    @objc func goToSignUpController(){
        let signUpVC = SignUpController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK: configure
    func configure(){
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.barTintColor = UIColor.tinderColor
        view.backgroundColor = UIColor.tinderColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureUI(){
        view.addSubview(midtermLabel)
        midtermLabel.translatesAutoresizingMaskIntoConstraints = false
        midtermLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        midtermLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        
        view.addSubview(loveLabel)
        loveLabel.translatesAutoresizingMaskIntoConstraints = false
        loveLabel.topAnchor.constraint(equalTo: midtermLabel.bottomAnchor, constant: 8).isActive = true
        loveLabel.leftAnchor.constraint(equalTo: midtermLabel.leftAnchor, constant: 60).isActive = true
        
        view.addSubview(emailTextFieldContainer)
        emailTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextFieldContainer.topAnchor.constraint(equalTo: loveLabel.bottomAnchor, constant: 70).isActive = true
        emailTextFieldContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        emailTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        
        view.addSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: 10).isActive = true
        passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 10).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        
        view.addSubview(textGoToSignUpView1)
        textGoToSignUpView1.translatesAutoresizingMaskIntoConstraints = false
        textGoToSignUpView1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        textGoToSignUpView1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30).isActive = true
        
        view.addSubview(textGoToSignUpView2)
        textGoToSignUpView2.translatesAutoresizingMaskIntoConstraints = false
        textGoToSignUpView2.leftAnchor.constraint(equalTo: textGoToSignUpView1.rightAnchor, constant: 5).isActive = true
        textGoToSignUpView2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    

}
