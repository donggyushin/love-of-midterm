//
//  ChangeProfileController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/02.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage
import GrowingTextView
import YPImagePicker
import LoadingShimmer

class ChangeProfileController: UIViewController {
    
    // MARK: Properties
    let user:User
    var address:Address
    
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
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
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
        tf.font = UIFont(name: "BMJUAOTF", size: 14)
        tf.textColor = .lightGray
        tf.text = ""
        tf.autocorrectionType = .no
        tf.placeholder = "사용자들에게 보여지게 됩니다"
        return tf
    }()
    
    lazy var dividerUnderUsername:UIView = {
        let view = UIView()
        view.backgroundColor = .tinderColor
        return view
    }()
    
    lazy var addressIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "home_unselected")
        iv.image = iv.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iv.tintColor = .tinderColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToSearchAddressViewController))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var addressLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToSearchAddressViewController))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var dividerUnderAddress:UIView = {
        let view = UIView()
        view.backgroundColor = .tinderColor
        return view
    }()
    
    lazy var shortBioLabel:UILabel = {
        let label = UILabel()
        label.text = "짧은 자기소개"
        label.textColor = .lightGray
        label.font = UIFont(name: "BMJUAOTF", size: 14)
        return label
    }()
    
    lazy var shortBioTextView:GrowingTextView = {
        let tv = GrowingTextView()
        tv.maxLength = 225
        tv.trimWhiteSpaceWhenEndEditing = true
        tv.minHeight = 40
        tv.maxHeight = 100
        tv.font = UIFont(name: "BMJUAOTF", size: 12)
        tv.textColor = .black
        tv.backgroundColor = .veryLightGray
        tv.autocorrectionType = .no
        return tv
    }()
    
    lazy var submitButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("프로필 변경하기", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.setTitleColor(UIColor.tinderColor, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()

    // MARK: Life cycles
    
    init(user:User, address:Address) {
        self.user = user
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        navigationController?.setNavigationBarHidden(false, animated: true)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.barTintColor = .tinderColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    
    // MARK: Selectors
    @objc func goToSearchAddressViewController(){
        let searchAddressVC = SearchAddressController()
        searchAddressVC.delegate = self
        self.navigationController?.pushViewController(searchAddressVC, animated: true)
    }
    
    @objc func profileImageTapped(){
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.wordings.libraryTitle = "사진첩"
        config.wordings.albumsTitle = "앨범"
        config.wordings.cameraTitle = "카메라"
        config.wordings.filter = "필터"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.hidesBottomBar = true
        config.colors.tintColor = .lightGray
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            for item in items {
                switch item {
                case .photo(let photo):
                    if let modifiedImage = photo.modifiedImage {
                        self.profileView.image = modifiedImage
                    }else {
                        
                        let originalImage = photo.originalImage
                        self.profileView.image = originalImage
                    }
                    
                case .video(_):
                    print("video picked")
                    
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
                         
        }
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated:true, completion: nil)
        
        
    }
    
    @objc func submitButtonTapped(){
        print("submit button tapped")
        LoadingShimmer.startCovering(self.view, with: nil)
        guard let profileImage = self.profileView.image else { return }
        guard let username = usernameTextField.text else { return }
        guard let bio = shortBioTextView.text else { return }
        
        if username == "" {
            self.popupDialog(title: "죄송합니다", message: "이름을 입력해주세요", image: #imageLiteral(resourceName: "logo"))
            return
        }
    
        UserService.shared.changeUserProfile(image: profileImage, username: username, address: address, bio: bio, user: user) { (error, errorString) in
            LoadingShimmer.stopCovering(self.view)
            if let error = error {
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "logo"))
            }else if let errorString = errorString {
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다", message: errorString, image: #imageLiteral(resourceName: "logo"))
            }else {
                RootViewController.rootViewController.fetchUser()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        
        if shortBioTextView.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == self.topBarHeight {
                    self.view.frame.origin.y -= keyboardSize.height / 2
                }
            }
        }
        
    }

    @objc override func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = self.topBarHeight
        }
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: configures
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func configureUser(){
        if let url = URL(string: user.profileImageUrl) {
            profileView.sd_setImage(with: url, completed: nil)
        }
        usernameTextField.text = user.username
        shortBioTextView.text = user.bio
        addressLabel.text = address.address
    }
    
    func configure(){
        hideKeyboardWhenTappedAround()
        configureUI()
        configureNavigationBar()
        configureUser()
        shortBioTextView.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
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
        
        
        view.addSubview(addressIcon)
        addressIcon.translatesAutoresizingMaskIntoConstraints = false
        addressIcon.topAnchor.constraint(equalTo: dividerUnderUsername.bottomAnchor, constant: 20).isActive = true
        addressIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        view.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: dividerUnderUsername.bottomAnchor, constant: 22).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: addressIcon.rightAnchor, constant: 10).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(dividerUnderAddress)
        dividerUnderAddress.translatesAutoresizingMaskIntoConstraints = false
        dividerUnderAddress.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8).isActive = true
        dividerUnderAddress.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        dividerUnderAddress.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        dividerUnderAddress.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        view.addSubview(shortBioLabel)
        shortBioLabel.translatesAutoresizingMaskIntoConstraints = false
        shortBioLabel.topAnchor.constraint(equalTo: dividerUnderAddress.bottomAnchor, constant: 40).isActive = true
        shortBioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        view.addSubview(shortBioTextView)
        shortBioTextView.translatesAutoresizingMaskIntoConstraints = false
        shortBioTextView.topAnchor.constraint(equalTo: shortBioLabel.bottomAnchor, constant: 30).isActive = true
        shortBioTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        shortBioTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: shortBioTextView.bottomAnchor, constant: 50).isActive = true
        submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
    }
    

}


extension ChangeProfileController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true 
    }
}

extension ChangeProfileController:UITextViewDelegate {
    
}

extension ChangeProfileController:SearchAddressControllerDelegate {
    func addressDidSelected(address: Address) {
        self.address = address
        addressLabel.text = address.address
    }
    
    
}
