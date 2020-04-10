//
//  UpdateTestViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/10.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class UpdateTestViewController: UIViewController {
    
    // MARK: Properties
    let test:Test
    
    // MARK: UIKits
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("뒤로", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()

    // MARK: Life cycles
    
    init(test:Test) {
        self.test = test
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        title = "\(test.num)번 문제"
        
        configure()
        
        guard let font = UIFont(name: "BMJUAOTF", size: 17) else { return }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.font:font
        ]
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: Selectors
    @objc func backbuttonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: configures
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = .white
    }

}
