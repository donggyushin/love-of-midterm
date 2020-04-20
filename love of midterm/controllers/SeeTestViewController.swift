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
        button.setTitle("\(test.num)번 문제", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        button.addTarget(self, action: #selector(backbuttonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    lazy var testTitleLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var questionOneLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var questionTwoLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var questionThreeLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var questionFourLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
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
    
    // MARK: Helpers
    
    func configureScrollViewHeight(){
        
        var height:CGFloat = 50 + 50 + 20 + 20 + 20 + 50
        height += EstimatedFrame.shared.getEstimatedFrame(messageText: test.title, width: Int(view.frame.width) - 40, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)).height  + EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionOne, width: Int(view.frame.width) - 40, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)).height + EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionOne, width: Int(view.frame.width) - 40, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)).height + EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionOne, width: Int(view.frame.width) - 40, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)).height + EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionOne, width: Int(view.frame.width) - 40, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)).height
        self.scrollView.contentSize.height = height
        
    }
    
    func configureTest(){
        testTitleLabel.text = test.title
        questionOneLabel.text = test.questionOne
        questionTwoLabel.text = test.questionTwo
        questionThreeLabel.text = test.questionThree
        questionFourLabel.text = test.questionFour
        
        switch test.answer {
        case 1:
            questionOneLabel.textColor = .tinderColor
        case 2:
            questionTwoLabel.textColor = .tinderColor
        case 3:
            questionThreeLabel.textColor = .tinderColor
        case 4:
            questionFourLabel.textColor = .tinderColor
            
        default:
            print("nothing")
        }
    }
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두울때
            view.backgroundColor = .black
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.barStyle = .black
            testTitleLabel.textColor = .white
            questionOneLabel.textColor = .white
            questionTwoLabel.textColor = .white
            questionThreeLabel.textColor = .white
            questionFourLabel.textColor = .white
        }else {
            // 환할때
            view.backgroundColor = .white
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.barStyle = .default
            testTitleLabel.textColor = .black
            questionOneLabel.textColor = .black
            questionTwoLabel.textColor = .black
            questionThreeLabel.textColor = .black
            questionFourLabel.textColor = .black
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
        configureTest()
        configureScrollViewHeight()
    }
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.barTintColor = .black
        }else {
            navigationController?.navigationBar.barTintColor = .white
        }
        
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(testTitleLabel)
        testTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        testTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        testTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        testTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(questionOneLabel)
        questionOneLabel.translatesAutoresizingMaskIntoConstraints = false
        questionOneLabel.topAnchor.constraint(equalTo: testTitleLabel.bottomAnchor, constant: 50).isActive = true
        questionOneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        questionOneLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(questionTwoLabel)
        questionTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        questionTwoLabel.topAnchor.constraint(equalTo: questionOneLabel.bottomAnchor, constant: 20).isActive = true
        questionTwoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        questionTwoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(questionThreeLabel)
        questionThreeLabel.translatesAutoresizingMaskIntoConstraints = false
        questionThreeLabel.topAnchor.constraint(equalTo: questionTwoLabel.bottomAnchor, constant: 20).isActive = true
        questionThreeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        questionThreeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(questionFourLabel)
        questionFourLabel.translatesAutoresizingMaskIntoConstraints = false
        questionFourLabel.topAnchor.constraint(equalTo: questionThreeLabel.bottomAnchor, constant: 20).isActive = true
        questionFourLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        questionFourLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }

}
