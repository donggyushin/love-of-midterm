//
//  SignUpController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    // MARK: Properties
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 20)
        button.addTarget(self, action: #selector(goBackToLoginView), for: .touchUpInside)
        return button
    }()
    
    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: selectors
    
    @objc func goBackToLoginView(){
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: configure
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func configure(){
        configureNavigationBar()
        view.backgroundColor = UIColor.tinderColor

    }
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    

}
