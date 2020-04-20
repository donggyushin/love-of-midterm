//
//  DeveloperViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/21.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import LoadingShimmer
import SDWebImage

class DeveloperViewController: UIViewController {

    // MARK: Properties
    var developer:User? {
        didSet {
            configureUser()
        }
    }
    
    // MARK: UIKits
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("개발자소개", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        
        button.addTarget(self, action: #selector(backbuttonTapped), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    

    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 35
        iv.backgroundColor = .veryLightGray
        iv.layer.borderWidth = 2.5
        iv.contentMode = .scaleAspectFill
        if self.traitCollection.userInterfaceStyle == .dark {
            iv.layer.borderColor = UIColor.white.cgColor
        }else {
            iv.layer.borderColor = UIColor.black.cgColor
        }
        
        return iv
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = "신동규"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        return label
    }()
    
    lazy var bioTextLabel:UILabel = {
        let label = UILabel()
        label.text = "안녕하세요. 음악과 개발을 사랑하는 개발자입니다. 웹개발과 모바일 개발을 위주로 활동중에 있으며 프론트엔드와 백엔드 둘 다 좋아합니다. 언제나 최신동향을 따라가기 위해 노력하며, 사용자를 행복하게 해주는 서비스를 만드는 것을 즐깁니다."
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var instagramImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "instagram")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var instaIdButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("donggyu_00", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        
        button.addTarget(self, action: #selector(instagramButtonTapped), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    lazy var mediumImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "medium")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    lazy var mediumUrlLabel:UIButton = {
        let label = UIButton(type: UIButton.ButtonType.system)
        label.setTitle("@donggyu9410", for: UIControl.State.normal)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            label.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        
        label.addTarget(self, action: #selector(mediumButtonTapped), for: UIControl.Event.touchUpInside)
        
        return label
    }()
    
    lazy var youtubeLogoImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "youtube")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var youtubeUrl:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Treduler", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        button.addTarget(self, action: #selector(youtubeTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
    // MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            LoadingShimmer.startCovering(self.view, with: nil)
        }
        
        configure()
        fetchDeveloper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    // MARK: Selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    func configureUser(){
        guard let developer = self.developer else { return }
        
        if let url = URL(string: developer.profileImageUrl) {
            self.profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        LoadingShimmer.stopCovering(self.view)
    }
    
    // MARK: APIs
    func fetchDeveloper(){
        UserService.shared.fetchDeveloper { (error, user) in
            if let error = error {
                print(error.localizedDescription)
                self.popupDialog(title: "죄송합니다", message: "유저의 정보를 불러오는데 실패하였습니다.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                guard let user = user else { return }
                self.developer = user
            }
        }
    }
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 다크 테마
            view.backgroundColor = .black
            navigationController?.navigationBar.barStyle = .black
            profileImageView.layer.borderColor = UIColor.white.cgColor
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            navigationController?.navigationBar.barTintColor = .black
            usernameLabel.textColor = .white
            bioTextLabel.textColor = .white
            instaIdButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            mediumUrlLabel.setTitleColor(UIColor.white, for: UIControl.State.normal)
            youtubeUrl.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            // 라이트 테마
            view.backgroundColor = .white
            navigationController?.navigationBar.barStyle = .default
            profileImageView.layer.borderColor = UIColor.black.cgColor
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            navigationController?.navigationBar.barTintColor = .white
            usernameLabel.textColor = .black
            bioTextLabel.textColor = .black
            instaIdButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            mediumUrlLabel.setTitleColor(UIColor.black, for: UIControl.State.normal)
            youtubeUrl.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
    }
    
    // MARK: Selectors
    @objc func instagramButtonTapped(){
        let wv = WebViewController(url: "https://www.instagram.com/donggyu_00/?hl=ko")
        navigationController?.pushViewController(wv, animated: true)
    }
    
    @objc func mediumButtonTapped(){
        let wv = WebViewController(url: "https://medium.com/@donggyu9410")
        navigationController?.pushViewController(wv, animated: true)
    }
    
    @objc func youtubeTapped(){
        let webViewController = WebViewController(url: "https://www.youtube.com/channel/UCEu31Np3_ocJ0JEtuoSbXIA?view_as=subscriber")
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    // MARK: Configures
    func configure(){
        configureUI()
        configureNavigationBar()
    }
    
    func configureNavigationBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            
            navigationController?.navigationBar.barTintColor = .black
        }else {
            navigationController?.navigationBar.barTintColor = .white
        }
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
        
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 30).isActive = true
        
        view.addSubview(bioTextLabel)
        bioTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bioTextLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 40).isActive = true
        bioTextLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 30).isActive = true
        bioTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        
        view.addSubview(instagramImageView)
        instagramImageView.translatesAutoresizingMaskIntoConstraints = false
        instagramImageView.topAnchor.constraint(equalTo: bioTextLabel.bottomAnchor, constant: 40).isActive = true
        instagramImageView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 30).isActive = true
        instagramImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        instagramImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(instaIdButton)
        instaIdButton.translatesAutoresizingMaskIntoConstraints = false
        instaIdButton.topAnchor.constraint(equalTo: bioTextLabel.bottomAnchor, constant: 43).isActive = true
        instaIdButton.leftAnchor.constraint(equalTo: instagramImageView.rightAnchor, constant: 15).isActive = true
        
        view.addSubview(mediumImageView)
        mediumImageView.translatesAutoresizingMaskIntoConstraints = false
        mediumImageView.topAnchor.constraint(equalTo: instagramImageView.bottomAnchor, constant: 15).isActive = true
        mediumImageView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 33).isActive = true
        mediumImageView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        mediumImageView.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        view.addSubview(mediumUrlLabel)
        mediumUrlLabel.translatesAutoresizingMaskIntoConstraints = false
        mediumUrlLabel.leftAnchor.constraint(equalTo: mediumImageView.rightAnchor, constant: 15).isActive = true
        mediumUrlLabel.topAnchor.constraint(equalTo: instagramImageView.bottomAnchor, constant: 15).isActive = true
        
        view.addSubview(youtubeLogoImageView)
        youtubeLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        youtubeLogoImageView.topAnchor.constraint(equalTo: mediumImageView.bottomAnchor, constant: 15).isActive = true
        youtubeLogoImageView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 30).isActive = true
        youtubeLogoImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        youtubeLogoImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(youtubeUrl)
        youtubeUrl.translatesAutoresizingMaskIntoConstraints = false
        youtubeUrl.leftAnchor.constraint(equalTo: youtubeLogoImageView.rightAnchor, constant: 15).isActive = true
        youtubeUrl.topAnchor.constraint(equalTo: mediumImageView.bottomAnchor, constant: 17).isActive = true
    }

}
