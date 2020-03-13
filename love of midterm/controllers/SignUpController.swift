//
//  SignUpController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class SignUpController: UIViewController {
    
    // MARK: Properties
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 20)
        button.addTarget(self, action: #selector(goBackToLoginView), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "plus_photo")
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.widthAnchor.constraint(equalToConstant: 115).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 115).isActive = true
        iv.layer.cornerRadius = 35
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    lazy var emailTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        let textField = UITextField()
        
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        iconView.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
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
    
    lazy var usernameTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        let textField = UITextField()
        
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        iconView.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
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
        
        textField.attributedPlaceholder = NSAttributedString(string: "다른 유저들에게 보여지게 됩니다.",
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
        
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
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
        
        textField.attributedPlaceholder = NSAttributedString(string: "Password를 입력해주세요.",
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
    
    lazy var passwordTextFieldContainer2:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        let textField = UITextField()
        
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
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
        
        textField.attributedPlaceholder = NSAttributedString(string: "Password를 확인해주세요.",
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
    
    
    lazy var signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.setTitle("회원가입", for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var imagePicker:ImagePicker!
    
    
    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: selectors
    
    @objc func profileImageViewTapped(){
        
        self.imagePicker.present(from: self.view)
    }
    
    @objc func goBackToLoginView(){
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: configure
    
    func requestPermission(){
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {

            }
        }

        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                } else {}
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func configure(){
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        moveViewWithKeyboard()
        hideKeyboardWhenTappedAround()
        configureNavigationBar()
        view.backgroundColor = UIColor.tinderColor
        configureUI()
    }
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func configureUI(){
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(emailTextFieldContainer)
        emailTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextFieldContainer.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        
        
        view.addSubview(usernameTextFieldContainer)
        usernameTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextFieldContainer.topAnchor.constraint(equalTo: usernameTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(passwordTextFieldContainer2)
        passwordTextFieldContainer2.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldContainer2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextFieldContainer2.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordTextFieldContainer2.bottomAnchor, constant: 20).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    

}

extension SignUpController:ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        print(image)
    }
}
