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
            checkThisIsMyProfile()
        }
    }
    
    var distanceFromMe:String?
    
    // MARK: UIKits
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
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
        button.setTitle("더 많은 사진 보러가기", for: .normal)
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
        label.textColor = .black
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
        view.backgroundColor = .veryLightGray
        return view
    }()
    
    lazy var bioLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.textColor = .black
        return label
    }()
    
    lazy var challengeButtonTypeTwo:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화하기", for: .normal)
        button.setTitleColor(.tinderColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.addTarget(self, action: #selector(conversationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var challengeButton:UIView = {
        let view = UIView()
        let iv = UIImageView()
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.layer.cornerRadius = 25
        view.backgroundColor = .tinderColor
        view.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iv.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iv.image = #imageLiteral(resourceName: "mail")
        iv.image = iv.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iv.tintColor = .white
        
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 1.0
        view.layer.shadowColor = UIColor.darkGray.cgColor
        
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(conversationButtonTapped))
        view.addGestureRecognizer(tap)
        
        return view
    }()

    // MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func conversationButtonTapped(){
        guard let user = user else { return }
        guard let me = me else { return }
        
        
        var checked = true
        
        for matchedUserId in me.matchedUsers {
            if matchedUserId == user.id {
                checked = false
            }
        }
        
        
        
        if checked == false {
            
            // 바로 채팅창으로 넘겨주자
            self.popupDialog(title: "이미 매칭된 유저입니다", message: "이미 매칭된 유저의 시험문제는 다시 풀 수 없습니다.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            
        }else {
            let alert = UIAlertController(title: "\(user.username)님과 대화하시겠습니까?", message: "다른 유저와 대화하기 위해서는 해당 유저가 출제한 문제를 7문제 이상 맞추셔야 합니다. 그리고 한 유저에게는 하루에 한 번만 도전가능합니다.", preferredStyle: UIAlertController.Style.actionSheet)
            
            let agreeAction = UIAlertAction(title: "도전해볼래요", style: UIAlertAction.Style.default) { (action) in
                if user.id == me.id {
                    self.popupDialog(title: "죄송합니다", message: "본인에게는 도전할 수 없습니다.", image: #imageLiteral(resourceName: "loveOfMidterm"))
                    return
                }
                
                // 내가 이 유저한테 당일날 말을 걸었는지 안걸었는지를 알아야함.
                TryService.shared.checkWhetherUserCanTry(userId: user.id) { (error, bool) in
                    if let error = error {
                        self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
                    }else {
                        guard let bool = bool else { return }
                        if bool == true {
                            let testVC = TestController(user:user)
                            testVC.delegate = self
                            let popup = PopupDialog(viewController: testVC, preferredWidth: 400, tapGestureDismissal: false, panGestureDismissal: false)
                            
                            self.present(popup, animated: true, completion: nil)
                        }else {
                            self.popupDialog(title: "죄송합니다", message: "하루에 같은 유저에게 두 번 이상 도전하실 수 없습니다.", image: #imageLiteral(resourceName: "loveOfMidterm"))
                        }
                    }
                }
            }
            
            let disagreeAction = UIAlertAction(title: "조금 더 생각해볼래요", style: UIAlertAction.Style.cancel, handler: nil)
            
            alert.addAction(agreeAction)
            alert.addAction(disagreeAction)
            present(alert, animated: true, completion: nil)
        }
        
        
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
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.distanceLabel.text = "나와의 거리 \(distanceString!)km"
            }
        }
        
    }
    
    
    // MARK: configure
    func checkThisIsMyProfile(){
        guard let user = user else { return }
        guard let me = me else { return }
        if user.id == me.id {
            self.challengeButton.isHidden = true
        }
    }
    
    func configureUser(){
        guard let user = user else { return }
        
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        usernameLabel.text = user.username
        
        
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
        
        
        let attributedString = NSMutableAttributedString(string: user.bio)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        bioLabel.attributedText = attributedString
        let attributedStringHeight = attributedString.height(containerWidth: view.frame.width * 0.9)
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: 550 + attributedStringHeight)
        
        TryService.shared.checkWhetherUserCanTry(userId: user.id) { (error, bool) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                guard let bool = bool else { return }
                if bool == false {
                    self.challengeButton.isHidden = true 
                }
            }
        }
        
    }
    
    func configure(){
        view.backgroundColor = .white
        configureNavigation()
        configureUI()
    }
    
    func configureNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    
    
    func configureUI(){
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 896)
        
        scrollView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        scrollView.addSubview(moreProfileImageButton)
        moreProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        moreProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 6).isActive = true
        moreProfileImageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        scrollView.addSubview(genderIcon)
        genderIcon.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        genderIcon.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
        
        
        scrollView.addSubview(birthdayLabel)
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
        bioLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(challengeButton)
        challengeButton.translatesAutoresizingMaskIntoConstraints = false
        challengeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        challengeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
//        view.addSubview(profileImageView)
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//
//        view.addSubview(moreProfileImageButton)
//        moreProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
//        moreProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 6).isActive = true
//        moreProfileImageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//
//
//        view.addSubview(usernameLabel)
//        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
//        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
//
//        view.addSubview(genderIcon)
//        genderIcon.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
//        genderIcon.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
//
//        view.addSubview(birthdayLabel)
//        birthdayLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true
//        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
//
//        view.addSubview(distanceLabel)
//        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
//        distanceLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 10).isActive = true
//        distanceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
//
//
//        view.addSubview(divider)
//        divider.translatesAutoresizingMaskIntoConstraints = false
//        divider.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 15).isActive = true
//        divider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        view.addSubview(bioLabel)
//        bioLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15).isActive = true
//        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
//        bioLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
//
//
//
//        view.addSubview(challengeButton)
//        challengeButton.translatesAutoresizingMaskIntoConstraints = false
//        challengeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        challengeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
}

// MARK: TestController Delegate

extension ProfileControllerTypeTwo:TestControllerDelegate {
    func popupResultControllerTypeTwo(view: TestController) {
        let resultVC = ResultControllerTypeTwo()
        let popup = PopupDialog(viewController: resultVC)
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func popupResultController(view: TestController) {
        
        let user = view.user
        let correctCount = view.correctCount
        
        let resultVC = ResultController(user: user, correctCount: correctCount)
        let popup = PopupDialog(viewController: resultVC)
        
//        let popup = PopupDialog(viewController: testVC, preferredWidth: 400, tapGestureDismissal: false, panGestureDismissal: false)
        
        self.present(popup, animated: true, completion: nil)
    }
}


extension ProfileControllerTypeTwo:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true 
    }
}
