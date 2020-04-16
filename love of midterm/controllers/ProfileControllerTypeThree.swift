//
//  ProfileControllerTypeThree.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/16.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileControllerTypeThree: UIViewController {
    
    // MARK: Properties
    
    let user:User
    
    // MARK: UIKits
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(self.user.username, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        button.addTarget(self, action: #selector(backbuttonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        if self.traitCollection.userInterfaceStyle == .dark {
            iv.backgroundColor = .spaceGray
        }else {
            iv.backgroundColor = .veryLightGray
        }
        
        if let url = URL(string: self.user.profileImageUrl) {
            iv.sd_setImage(with: url, completed: nil)
        }
        
        return iv
    }()
    
    lazy var morePhotosButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("More photos", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        
        button.addTarget(self, action: #selector(morePhotosButtonTapped), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    lazy var goToSeeTests:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Tests", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        return button
    }()
    
    lazy var userNameLabel:UILabel = {
        let label = UILabel()
        label.text = self.user.username
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var birthdayLabel:UILabel = {
        let label = UILabel()
        let year = String(self.user.birthday.year())
        let yearSubstring = year.suffix(2)
        label.text = "\(yearSubstring)년생"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var divider:UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        return view
    }()
    
    lazy var bioTextLabel:UILabel = {
        let label = UILabel()
        label.text = user.bio
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()

    // MARK: Life cycles
    
    init(user:User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        calculateHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    // MARK: 테마 바뀔 때
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 다크
            self.navigationController?.navigationBar.barStyle = .black
            view.backgroundColor = .black
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            profileImageView.backgroundColor = .spaceGray
            morePhotosButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            goToSeeTests.setTitleColor(UIColor.white, for: UIControl.State.normal)
            userNameLabel.textColor = .white
            birthdayLabel.textColor = .white
            bioTextLabel.textColor = .white
        }else {
            // 라이트
            self.navigationController?.navigationBar.barStyle = .default
            view.backgroundColor = .white
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            profileImageView.backgroundColor = .veryLightGray
            morePhotosButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            goToSeeTests.setTitleColor(UIColor.black, for: UIControl.State.normal)
            userNameLabel.textColor = .black
            birthdayLabel.textColor = .black
            bioTextLabel.textColor = .black
        }
    }
    
    // MARK: Helpers
    
    func calculateHeight(){
        var height:CGFloat = 0
        height += view.frame.width
        height += 200
        height += EstimatedFrame.shared.getEstimatedFrame(messageText: self.user.bio, width: Int(view.frame.width - 20), font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)).height
        
        scrollView.contentSize.height = height
        
        
    }
    
    // MARK: Selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func morePhotosButtonTapped(){
        let moreUserImageController = MoreUserImageController(backgroundImages: user.backgroundImages)
        navigationController?.pushViewController(moreUserImageController, animated: true)
    }
    
    // MARK: Configures
    func configure(){
        configureUI()
        configureNavigationBar()
    }
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        scrollView.addSubview(morePhotosButton)
        morePhotosButton.translatesAutoresizingMaskIntoConstraints = false
        morePhotosButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        morePhotosButton.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(goToSeeTests)
        goToSeeTests.translatesAutoresizingMaskIntoConstraints = false
        goToSeeTests.topAnchor.constraint(equalTo: morePhotosButton.bottomAnchor, constant: 7).isActive = true
        goToSeeTests.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: goToSeeTests.bottomAnchor, constant: 0).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        scrollView.addSubview(birthdayLabel)
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.topAnchor.constraint(equalTo: goToSeeTests.bottomAnchor, constant: 2).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: userNameLabel.rightAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        divider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        divider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(bioTextLabel)
        bioTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bioTextLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20).isActive = true
        bioTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        bioTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
    }
    
    
    

}
