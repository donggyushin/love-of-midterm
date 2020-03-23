//
//  ChoiceController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ChoiceController: UIViewController {
    // MARK: Properties
    let user:User
    
    let me:User
    
    let request:Request
    
    // MARK: UIKits
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("알림", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.setTitleColor(.tinderColor, for: .normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        iv.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemGroupedBackground
        return iv
    }()
    
    lazy var moreProfileImageButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("더 많은 사진 보러가기", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 13)
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        return button
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신다혜"
        label.font = UIFont(name: "BMJUAOTF", size: 15)
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
    }
    
    // MARK: Selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: APIs
    func updateRequestCheckedStatus(){
        if request.checked == false {
            RequestService.shared.updateRequestCheckedStatus(id: request.id)
        }
    }
    
    // MARK: Configure
    func configure(){
        view.backgroundColor = .white
        configureUI()
        configureNavigationBar()
        updateRequestCheckedStatus()
    }
    
    func configureUI(){
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        view.addSubview(moreProfileImageButton)
        moreProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        moreProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 6).isActive = true
        moreProfileImageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true 
        
    }
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BMJUAOTF", size: 18)!,
                                                                        NSAttributedString.Key.foregroundColor:UIColor.tinderColor
        ]
        self.navigationItem.title = "\(user.username)님의 요청"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    

}
