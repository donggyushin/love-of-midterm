//
//  ResultController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ResultController: UIViewController {
    
    // MARK: properties
    let user:User
    let me:User
    
    let correctCount:Int
    
    // MARK: UIKits
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "축하합니다!"
        label.font = UIFont(name: "BMJUAOTF", size: 16)
        label.textColor = .tinderColor
        return label
    }()
    
    lazy var infoLabel:UILabel = {
        let label = UILabel()
        label.text = "총 10문제중 \(self.correctCount)문제를 맞추셨습니다."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var resultLabel:UILabel = {
        let label = UILabel()
        label.text = "이제 \(self.user.username)님으로부터 앞으로의 대화 여부에 관한 동의를 얻으면 대화를 시작하실 수 있습니다."
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var okayButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.addTarget(self, action: #selector(okayButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Life cycle
    
    init(user:User, me:User, correctCount:Int) {
        self.user = user
        self.me = me
        self.correctCount = correctCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createNewRequest()
    }
    
    // MARK: APIs
    
    func createNewRequest(){
        RequestService.shared.createRequest(me:me, to: user) { (error) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                print("\(self.user.username)에게 request 성공")
            }
        }
    }
    
    // MARK: Selectors
    @objc func okayButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: configures
    func configure(){
        self.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.view.backgroundColor = .white
        configureUI()
    }
    
    func configureUI(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20).isActive = true
        resultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        resultLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(okayButton)
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        okayButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 50).isActive = true
        okayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}
