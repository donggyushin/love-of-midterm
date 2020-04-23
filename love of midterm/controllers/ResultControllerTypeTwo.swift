//
//  ResultControllerTypeTwo.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ResultControllerTypeTwo: UIViewController {
    
    // MARK: Properties
    
    let correctCount:Int
    let user:User

    // MARK: UIKits
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "아쉽네요 ㅠ_ㅠ"
        label.font = UIFont(name: "BMJUAOTF", size: 16)
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var infoLabel:UILabel = {
        let label = UILabel()
        label.text = "총 10문제중 3문제를 맞추셨습니다."
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var resultLabel:UILabel = {
        let label = UILabel()
        label.text = "다시 한 번 도전해보세요!"
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        
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
    
    init(user:User, correctCount:Int) {
        self.user = user
        self.correctCount = correctCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: 테마 바꼈을 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            
            // 다크테마
            view.backgroundColor = .spaceGray
            titleLabel.textColor = .white
            infoLabel.textColor = .white
            resultLabel.textColor = .white
        }else {
            // 라이트테마
            view.backgroundColor = .white
            titleLabel.textColor = .black
            infoLabel.textColor = .black
            resultLabel.textColor = .black
        }
    }
    
    // MARK: Selectors
    @objc func okayButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: configures
    func configure(){
        self.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
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
        okayButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20).isActive = true
        okayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }

}
