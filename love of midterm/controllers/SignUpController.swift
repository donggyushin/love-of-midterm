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
    
    var profileImage:UIImage?
    
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
    
    let emailTextField = UITextField()
    
    lazy var emailTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        
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
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email@gmail.com",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.font = UIFont(name: "BMJUAOTF", size: 17)
        emailTextField.textColor = .white
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        return view
    }()
    
    let usernameTextField = UITextField()
    
    lazy var usernameTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        
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
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "다른 유저들에게 보여지게 됩니다.",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        usernameTextField.font = UIFont(name: "BMJUAOTF", size: 17)
        usernameTextField.textColor = .white
        view.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        return view
    }()
    
    let password1TextField = UITextField()
    
    lazy var passwordTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        
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
        
        password1TextField.attributedPlaceholder = NSAttributedString(string: "Password를 입력해주세요.",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password1TextField.textColor = .white
        view.addSubview(password1TextField)
        password1TextField.isSecureTextEntry = true
        password1TextField.font = UIFont(name: "BMJUAOTF", size: 17)
        password1TextField.translatesAutoresizingMaskIntoConstraints = false
        password1TextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 3).isActive = true
        password1TextField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        password1TextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        password1TextField.autocapitalizationType = .none
        password1TextField.autocorrectionType = .no
        return view
    }()
    
    let password2TextField = UITextField()
    
    lazy var passwordTextFieldContainer2:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        
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
        
        password2TextField.attributedPlaceholder = NSAttributedString(string: "Password를 확인해주세요.",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password2TextField.textColor = .white
        view.addSubview(password2TextField)
        password2TextField.isSecureTextEntry = true
        password2TextField.font = UIFont(name: "BMJUAOTF", size: 17)
        password2TextField.translatesAutoresizingMaskIntoConstraints = false
        password2TextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 3).isActive = true
        password2TextField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        password2TextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        password2TextField.autocapitalizationType = .none
        password2TextField.autocorrectionType = .no
        return view
    }()
    
    
    lazy var signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 17)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
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
    
    @objc func signUpButtonTapped(){
        // TODO: custom modal 을 준비하고오는게 좋을듯 하오
        guard let profileImage = profileImage,
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password1 = password1TextField.text,
            let password2 = password2TextField.text
        else {
            
            self.popupDialog(title: "입력에 빠진 부분이 있습니다!", message: "회원가입에 필요한 양식중 입력하지 않은 사항이 있지 않나요?", image: #imageLiteral(resourceName: "loveOfMidterm"))
            return
        }
        
        if (email == "" || username == "" || password1 == "" || password2 == ""){
            self.popupDialog(title: "입력에 빠진 부분이 있습니다!", message: "회원가입에 필요한 양식중 입력하지 않은 사항이 있지 않나요?", image: #imageLiteral(resourceName: "loveOfMidterm"))
            return
        }
        
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
        profileImageView.image = image
        profileImage = image
    }
}
