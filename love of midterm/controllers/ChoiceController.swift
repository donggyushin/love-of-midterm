//
//  ChoiceController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage
import LoadingShimmer

class ChoiceController: UIViewController {
    // MARK: Properties
    let user:User
    
    let me:User
    
    let request:Request
    
    // MARK: UIKits
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("알림", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(.white, for: .normal)
        }else {
            button.setTitleColor(.black, for: .normal)
        }
        
        
        return button
    }()
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        iv.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .veryLightGray
        return iv
    }()
    
    lazy var moreProfileImageButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("더 많은 사진 보러가기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: .normal)
        }else {
            button.setTitleColor(UIColor.black, for: .normal)
        }
        
        
        return button
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var genderIcon:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        return iv
    }()
    
    lazy var birthdayLabel:UILabel = {
        let label = UILabel()
        label.text = "??년생"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var distanceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나와의 거리 ??km"
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var divider:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.9).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .veryLightGray
        return view
    }()
    
    
    lazy var bioLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .white
        }
        
        return label
    }()
    
    lazy var xLabel:UIButton = {
        let label = UIButton(type: UIButton.ButtonType.system)
        label.setTitle("거절할게요", for: .normal)
        label.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        label.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.setTitleColor(.white, for: .normal)
        }else {
            label.setTitleColor(.black, for: .normal)
        }
        
        
        return label
    }()
    
    lazy var oLabel:UIButton = {
        let label = UIButton(type: UIButton.ButtonType.system)
        label.setTitle("대화 시작하기", for: .normal)
        label.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        label.addTarget(self, action: #selector(startConversationButtonTapped), for: .touchUpInside)
        
        if self.traitCollection.userInterfaceStyle == .dark {

            label.setTitleColor(.white, for: .normal)
        }else {
            label.setTitleColor(.black, for: .normal)
        }
        
        
        return label
    }()

    // MARK: Life Cycle
    
    init(user:User, me:User, request:Request) {
        self.user = user
        self.me = me
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: 테마가 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두운 테마일때
            self.navigationController?.navigationBar.barStyle = .black
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            navigationController?.navigationBar.barTintColor = .black
            self.view.backgroundColor = .black
            moreProfileImageButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            usernameLabel.textColor = .white
            bioLabel.textColor = .white
            xLabel.setTitleColor(UIColor.white, for: .normal)
            oLabel.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.white
            ]
            self.navigationItem.title = "\(user.username)님의 요청"
            navigationController?.navigationBar.barTintColor = .black
        }else {
            // 밝은 테마일때
            self.navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.barTintColor = .white
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.view.backgroundColor = .white
            moreProfileImageButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            usernameLabel.textColor = .black
            bioLabel.textColor = .black
            xLabel.setTitleColor(UIColor.black, for: .normal)
            oLabel.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.black
            ]
            self.navigationItem.title = "\(user.username)님의 요청"
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    // MARK: Selectors
    
    @objc func startConversationButtonTapped(){
        
        self.oLabel.isEnabled = false
        
        LoadingShimmer.startCovering(self.view, with: nil)
        
        UserService.shared.matchingUser(userId: self.user.id)
        RequestService.shared.updateRequestCheckedStatus(id: self.request.id)
        ChatService.shared.createNewChat(userId: self.user.id) { (error, chat) in
            RequestService.shared.updateRequestCheckedStatus(id: self.request.id)
            LoadingShimmer.stopCovering(self.view)
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.disableButtons()
                guard let chat = chat else { return }
                let chatVC = ChatController(chat: chat, me: self.me)
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
        
    }
    
    @objc func denyButtonTapped(){
        let alert = UIAlertController(title: "정말로 거절하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let denyAction = UIAlertAction(title: "네, 거절할게요", style: UIAlertAction.Style.destructive) { (action) in
            
            RequestService.shared.updateRequestCheckedStatus(id: self.request.id)
            
            self.disableButtons()
            
            RequestService.shared.createDenyRequest(user: self.user, me: self.me) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        let defaultAction = UIAlertAction(title: "다시 생각해볼게요", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(defaultAction)
        alert.addAction(denyAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonTapped(){
        let moreUserImageController = MoreUserImageController(backgroundImages: user.backgroundImages)
        
        navigationController?.pushViewController(moreUserImageController, animated: true)
    }
    
    // MARK: Helpers
    
    func disableButtons(){
        self.xLabel.isEnabled = false
        self.xLabel.setTitleColor(.lightGray, for: .normal)
        self.oLabel.isEnabled = false
        self.oLabel.setTitleColor(.lightGray, for: .normal)
    }
    
    // MARK: APIs
    func updateRequestCheckedStatus(){
        if request.checked == false {
            RequestService.shared.updateRequestCheckedStatus(id: request.id)
        }
    }
    
    // MARK: Configure
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    
    func configureScrollHeight(){
        guard let font = UIFont(name: "BMJUAOTF", size: 14) else { return }
        
        let bioTextHeight = user.bio.height(withConstrainedWidth: view.frame.width * 0.9, font: font)
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: 640 + bioTextHeight)
    }
    
    
    func configure(){
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
        
        
        
        
        if request.checked == true {
            disableButtons()
        }
        configureUI()
        configureNavigationBar()
        configureUser()
        configureScrollHeight()
    }
    
    
    func configureUser(){
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        usernameLabel.text = user.username
        bioLabel.text = user.bio
        
        AddressService.shared.calculateTwoDistance(id1: user.addressId, id2: me.addressId) { (error, distanceString) in
            
            
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                
                self.distanceLabel.text = "나와의 거리 \(distanceString!)km"
            }
        }
        
        let birthdayYear = String(user.birthday.year())
        birthdayLabel.text = String(birthdayYear.suffix(2))+"년생"
        
        if user.gender == "female" {
            genderIcon.image = #imageLiteral(resourceName: "female")
            genderIcon.image = genderIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            genderIcon.tintColor = .tinderColor
        }else {
            genderIcon.image = #imageLiteral(resourceName: "male")
            genderIcon.image = genderIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            genderIcon.tintColor = .facebookBlue
        }
    }
    
    func configureNavigationBar(){
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.white
            ]
            self.navigationItem.title = "\(user.username)님의 요청"
            navigationController?.navigationBar.barTintColor = .black
        }else {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.black
            ]
            self.navigationItem.title = "\(user.username)님의 요청"
            navigationController?.navigationBar.barTintColor = .white
        }
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        navigationController?.navigationBar.isTranslucent = true

        
    }
    
    
    func configureUI(){
        
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
        
        scrollView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        scrollView.addSubview(moreProfileImageButton)
        moreProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        moreProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 6).isActive = true
        moreProfileImageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        scrollView.addSubview(genderIcon)
        genderIcon.translatesAutoresizingMaskIntoConstraints = false
        genderIcon.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        genderIcon.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 6).isActive = true
        
        
        scrollView.addSubview(birthdayLabel)
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        scrollView.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 10).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        scrollView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 15).isActive = true
        divider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        scrollView.addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(xLabel)
        xLabel.translatesAutoresizingMaskIntoConstraints = false
        xLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 70).isActive = true
        xLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60).isActive = true
        
        scrollView.addSubview(oLabel)
        oLabel.translatesAutoresizingMaskIntoConstraints = false
        oLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 70).isActive = true
        oLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60).isActive = true
        
        
    }
    

}

extension ChoiceController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
