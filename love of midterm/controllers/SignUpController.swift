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
import LoadingShimmer
import DatePicker

class SignUpController: UIViewController {
    
    // MARK: properties
    
    let simpleDatePicker = UIDatePicker()
    
    var profileImage:UIImage?
    
    let emailTextField = UITextField()
    
    let usernameTextField = UITextField()
    
    lazy var birthdayTextField:UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    var gender:String = "male"
    
    var birthdayDateValue:Date?
    
    var addressTextField = UILabel()
    
    var addressValue:Address?
    
    let password1TextField = UITextField()
    
    let password2TextField = UITextField()
    
    // MARK: UIkits
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.contentSize.height = 850
        return sv
    }()
    
    lazy var viewInScrollView:UIView = {
        let view = UIView()
        return view
    }()
    
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
        emailTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
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
        usernameTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
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
    
    
    
    
    lazy var birthdayTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        iconView.image = #imageLiteral(resourceName: "calendar")
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
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
        
        birthdayTextField.attributedPlaceholder = NSAttributedString(string: "생년월일을 입력해주세요.", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        birthdayTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        
        view.addSubview(birthdayTextField)
        birthdayTextField.translatesAutoresizingMaskIntoConstraints = false
        birthdayTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1).isActive = true
        birthdayTextField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.autocapitalizationType = .none
        birthdayTextField.autocorrectionType = .no
        
        return view
    }()
    
    
    lazy var genderSelectorContainer:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
        return view
    }()
    
    lazy var maleButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("남자", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 17)
        button.setTitleColor(.tinderColor, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var femailButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("여자", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .tinderColor
        button.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    lazy var addressTextFieldContainer:UIView = {
        let view = UIView()
        let iconView = UIImageView()
        let bottomLine = UIView()
        
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        iconView.image = #imageLiteral(resourceName: "mail")
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
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
        
        addressTextField.text = "주소를 입력해주세요"
        addressTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        addressTextField.textColor = .white
        addressTextField.isUserInteractionEnabled = false
        view.addSubview(addressTextField)
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        addressTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1).isActive = true
        addressTextField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        addressTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addressTextFieldTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        
        return view
    }()
    
    
    
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
        password1TextField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        password1TextField.translatesAutoresizingMaskIntoConstraints = false
        password1TextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 3).isActive = true
        password1TextField.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 15).isActive = true
        password1TextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        password1TextField.autocapitalizationType = .none
        password1TextField.autocorrectionType = .no
        return view
    }()
    
    
    
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
        password2TextField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
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
    
    
    // MARK: helpers
    
    func setAddress(address:Address){
        addressTextField.text = address.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: " ")
        addressValue = address
    }
    
    
    // MARK: selectors
    
    @objc func addressTextFieldTapped(){
        let searchAddressVC = SearchAddressController()
        searchAddressVC.delegate = self
        navigationController?.pushViewController(searchAddressVC, animated: true)
    }
    
    
    @objc func maleButtonTapped(){
        self.gender = "male"
        self.maleButton.backgroundColor = .white
        self.maleButton.setTitleColor(.tinderColor, for: .normal)
        
        self.femailButton.backgroundColor = .tinderColor
        self.femailButton.setTitleColor(.white, for: .normal)
    }
    
    @objc func femaleButtonTapped(){
        self.gender = "female"
        self.femailButton.backgroundColor = .white
        self.femailButton.setTitleColor(.tinderColor, for: .normal)
        
        self.maleButton.backgroundColor = .tinderColor
        self.maleButton.setTitleColor(.white, for: .normal)
    }
    
    @objc func profileImageViewTapped(){
        
        self.imagePicker.present(from: self.view)
    }
    
    @objc func goBackToLoginView(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func signUpButtonTapped(){
        
        signUpButton.isEnabled = false
        backButton.isHidden = true
        LoadingShimmer.startCovering(self.view, with: nil)
        
        guard let profileImage = profileImage,
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password1 = password1TextField.text,
            let password2 = password2TextField.text
        else {
            
            self.popupDialog(title: "입력에 빠진 부분이 있습니다!", message: "회원가입에 필요한 양식중 입력하지 않은 사항이 있지 않나요?", image: #imageLiteral(resourceName: "loveOfMidterm"))
            self.signUpButton.isEnabled = true
            LoadingShimmer.stopCovering(self.view)
            backButton.isHidden = false
            return
        }
        
        if (email == "" || username == "" || password1 == "" || password2 == ""){
            self.popupDialog(title: "입력에 빠진 부분이 있습니다!", message: "회원가입에 필요한 양식중 입력하지 않은 사항이 있지 않나요?", image: #imageLiteral(resourceName: "loveOfMidterm"))
            self.signUpButton.isEnabled = true
            LoadingShimmer.stopCovering(self.view)
            backButton.isHidden = false
            return
        }
        
        if (password2 != password1) {
            popupDialog(title: "비밀번호가 서로 다릅니다!", message: "비밀번호를 다시 한 번 확인해보세요", image: #imageLiteral(resourceName: "loveOfMidterm"))
            self.signUpButton.isEnabled = true
            LoadingShimmer.stopCovering(self.view)
            backButton.isHidden = false
            return
        }
        
        // TODO:- 성별, 생년월일, 주소도 입력받은거를 확인해야함
        
        guard gender != "" else {
            popupDialog(title: "성별이 선택되어져 있지 않습니다. ", message: "성별을 선택해주세요.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            self.signUpButton.isEnabled = true
            LoadingShimmer.stopCovering(self.view)
            backButton.isHidden = false
            return
        }
        guard let birthdayDateValue = birthdayDateValue else {
            popupDialog(title: "생년월일이 선택되어져 있지 않습니다. ", message: "생년월일을 선택해주세요.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            self.signUpButton.isEnabled = true
            LoadingShimmer.stopCovering(self.view)
            backButton.isHidden = false
            return }
        guard let addressValue = self.addressValue else {
            popupDialog(title: "주소가 선택되어져 있지 않습니다. ", message: "주소를 선택해주세요.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            self.signUpButton.isEnabled = true
            LoadingShimmer.stopCovering(self.view)
            backButton.isHidden = false
            return
        }
        
        UserService.shared.requestToNewUser(email: email, password: password2, profileImage: profileImage, username: username, gender: gender, birthdayDateValue: birthdayDateValue, addressValue: addressValue) { (error, errorString) in
            if let error = error {
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
                self.signUpButton.isEnabled = true
                LoadingShimmer.stopCovering(self.view)
                self.backButton.isHidden = false
                return
            }
            if let errorString = errorString {
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다", message: errorString, image: #imageLiteral(resourceName: "loveOfMidterm"))
                self.signUpButton.isEnabled = true
                LoadingShimmer.stopCovering(self.view)
                self.backButton.isHidden = false
                return
            }
            
            // 회원가입 성공!!
            RootViewController.rootViewController.configure()
            LoadingShimmer.stopCovering(self.view)
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    // MARK: configure
    
    @objc func datepickerDoneTapped(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthdayDateValue = simpleDatePicker.date
        birthdayTextField.text = formatter.string(from: simpleDatePicker.date)
        self.view.endEditing(true)
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let customBtn = UIButton(type: UIButton.ButtonType.system)
        customBtn.setTitle("선택", for: .normal)
        customBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        customBtn.addTarget(self, action: #selector(datepickerDoneTapped), for: .touchUpInside)
        
        let doneBtn = UIBarButtonItem(customView: customBtn)
            
        
        toolbar.setItems([doneBtn], animated: true)
        
        birthdayTextField.inputAccessoryView = toolbar
        
        birthdayTextField.inputView = simpleDatePicker
        
        simpleDatePicker.datePickerMode = .date
    }
    
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
        createDatePicker()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        moveViewWithKeyboard()
        hideKeyboardWhenTappedAround()
        configureNavigationBar()
        view.backgroundColor = UIColor.tinderColor
        configureUI()
    }
    
    func configureNavigationBar(){
        self.makeNavigationBarTransparent()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func configureUI(){
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
        scrollView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        
        scrollView.addSubview(emailTextFieldContainer)
        emailTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        emailTextFieldContainer.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true


        scrollView.addSubview(usernameTextFieldContainer)
        usernameTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameTextFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        usernameTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: 10).isActive = true

        scrollView.addSubview(genderSelectorContainer)
        genderSelectorContainer.translatesAutoresizingMaskIntoConstraints = false
        genderSelectorContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        genderSelectorContainer.topAnchor.constraint(equalTo: usernameTextFieldContainer.bottomAnchor, constant: 20).isActive = true

        genderSelectorContainer.addSubview(maleButton)
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        maleButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4).isActive = true
        maleButton.leftAnchor.constraint(equalTo: genderSelectorContainer.leftAnchor).isActive = true
        maleButton.topAnchor.constraint(equalTo: genderSelectorContainer.topAnchor).isActive = true

        genderSelectorContainer.addSubview(femailButton)
        femailButton.translatesAutoresizingMaskIntoConstraints = false
        femailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        femailButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4).isActive = true
        femailButton.rightAnchor.constraint(equalTo: genderSelectorContainer.rightAnchor).isActive = true
        femailButton.topAnchor.constraint(equalTo: genderSelectorContainer.topAnchor).isActive = true
        
        scrollView.addSubview(birthdayTextFieldContainer)
        birthdayTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        birthdayTextFieldContainer.topAnchor.constraint(equalTo: genderSelectorContainer.bottomAnchor, constant: 20).isActive = true
        birthdayTextFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        
        
        scrollView.addSubview(addressTextFieldContainer)
        addressTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        addressTextFieldContainer.topAnchor.constraint(equalTo: birthdayTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        addressTextFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true


        scrollView.addSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        passwordTextFieldContainer.topAnchor.constraint(equalTo: addressTextFieldContainer.bottomAnchor, constant: 20).isActive = true

        scrollView.addSubview(passwordTextFieldContainer2)
        passwordTextFieldContainer2.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldContainer2.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        passwordTextFieldContainer2.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 20).isActive = true

        scrollView.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordTextFieldContainer2.bottomAnchor, constant: 10).isActive = true
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

extension SignUpController:SearchAddressControllerDelegate {
    func addressDidSelected(address: Address) {
        setAddress(address: address)
    }
}
