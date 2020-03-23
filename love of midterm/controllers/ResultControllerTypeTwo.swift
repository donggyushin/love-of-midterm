//
//  ResultControllerTypeTwo.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ResultControllerTypeTwo: UIViewController {

    // MARK: UIKits
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "아쉽네요 ㅠ_ㅠ"
        label.font = UIFont(name: "BMJUAOTF", size: 16)
        label.textColor = .tinderColor
        return label
    }()
    
    lazy var infoLabel:UILabel = {
        let label = UILabel()
        label.text = "총 10문제중 3문제를 맞추셨습니다."
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var resultLabel:UILabel = {
        let label = UILabel()
        label.text = "이제 신동규님께 다시 말을 거시려면 하루를 기다리신 후 다시 도전해보세요!"
        label.font = UIFont(name: "BMJUAOTF", size: 15)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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