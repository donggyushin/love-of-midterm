//
//  TestController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/21.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    
    lazy var closeButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("포기할래요", for: .normal)
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    // MARK: selectors
    @objc func closeButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: configure
    func configure(){
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 560).isActive = true
        
        configureUI()
    }
    
    func configureUI(){
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
    }

}
