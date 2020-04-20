//
//  SeeTestViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class SeeTestViewController: UIViewController {
    
    // MARK: Properties
    let test:Test
    
    // MARK: UIKits
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("문제", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
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
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두울때
            view.backgroundColor = .black
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.barStyle = .black
        }else {
            // 환할때
            view.backgroundColor = .white
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barStyle = .default
        }
    }
    
    // MARK: Selectors
    @objc func backbuttonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: configures
    
    func configure(){
        configureNavigationBar()
        configureUI()
    }
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.tintColor = .black
        }else {
            navigationController?.navigationBar.tintColor = .white
        }
        
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
    }

}
