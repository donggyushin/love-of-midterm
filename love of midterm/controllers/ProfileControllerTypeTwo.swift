//
//  ProfileControllerTypeTwo.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage
import PopupDialog

class ProfileControllerTypeTwo: UIViewController {
    
    // MARK: Properties
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    var me:User? {
        didSet {
            calculateDistanceFromMe()
        }
    }
    
    var distanceFromMe:String?
    
    // MARK: UIKits
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화상대 찾기", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.setTitleColor(.tinderColor, for: .normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var moreProfileImageButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("이용자의 더 많은 사진 보러가기", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 13)
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        return label
    }()
    
    lazy var genderIcon:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iv.image = #imageLiteral(resourceName: "female")
        iv.image = iv.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iv.tintColor = UIColor.tinderColor
        return iv
    }()
    
    lazy var birthdayLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 13)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var distanceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나와의 거리 ??km"
        label.font = UIFont(name: "BMJUAOTF", size: 13)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var divider:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.9).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    lazy var bioLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ui 짜는게 제일 힘드로~~"
        label.font = UIFont(name: "BMJUAOTF", size: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        
        return label
    }()
    
    lazy var challengeButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화하기", for: .normal)
        button.setTitleColor(.tinderColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.addTarget(self, action: #selector(conversationButtonTapped), for: .touchUpInside)
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
    
    @objc func conversationButtonTapped(){
        let testVC = TestController()
        
        let popup = PopupDialog(viewController: testVC, preferredWidth: 400, tapGestureDismissal: false, panGestureDismissal: false)
        
        self.present(popup, animated: true, completion: nil)
        
    }
    
    @objc func moreButtonTapped(){
        guard let user = user else { return }
        let moreUserImageVC = MoreUserImageController(backgroundImages: user.backgroundImages)
        navigationController?.pushViewController(moreUserImageVC, animated: true)
    }
    
    // MARK: helpers
    
    func calculateDistanceFromMe() {
        guard let user = user else { return }
        guard let me = me else { return }
        
        AddressService.shared.calculateTwoDistance(id1: user.addressId, id2: me.addressId) { (error, distanceString) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.distanceLabel.text = "나와의 거리 \(distanceString!)km"
            }
        }
        
    }
    
    
    // MARK: configure
    
    func configureUser(){
        guard let user = user else { return }
        
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        usernameLabel.text = user.username
        bioLabel.text = user.bio
        
        let birthdayYear = String(user.birthday.year())
        birthdayLabel.text = String(birthdayYear.suffix(2))+"년생"
    }
    
    func configure(){
        view.backgroundColor = .white
        configureNavigation()
        configureUI()
    }
    
    func configureNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func configureUI(){
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        view.addSubview(moreProfileImageButton)
        moreProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        moreProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 6).isActive = true
        moreProfileImageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        
        view.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        view.addSubview(genderIcon)
        genderIcon.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        genderIcon.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        view.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 10).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 15).isActive = true
        divider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(bioLabel)
        bioLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        view.addSubview(challengeButton)
        challengeButton.translatesAutoresizingMaskIntoConstraints = false
        challengeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        challengeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
