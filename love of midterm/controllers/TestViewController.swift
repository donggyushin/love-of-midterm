//
//  TestViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/10.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import LoadingShimmer

class TestViewController: UIViewController {
    
    // MARK: Properties
    let user:User
    
    var test:Test? {
        didSet {
            configureTest()
        }
    }
    
    // MARK: UIKits
    lazy var backbutton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("문제확인", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        button.addTarget(self, action: #selector(backbuttonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var numberOneLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.text = "1."
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        
        return label
    }()
    
    lazy var numberOneTextLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        
        return label
    }()
    
    lazy var numberTwoLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.text = "2."
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            label.textColor = .white
        }else {
            label.textColor = .black
        }
        
        return label
    }()
    
    lazy var numberTwoTextLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var numberThreeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.text = "3."
        return label
    }()
    
    lazy var numberThreeTextLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var numberFourLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.text = "4."
        return label
    }()
    
    lazy var numberFourTextLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var prevButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("이전", for: UIControl.State.normal)
        button.setTitleColor(UIColor.tinderColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(prevButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var nextButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("다음", for: UIControl.State.normal)
        button.setTitleColor(UIColor.tinderColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(nextButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()

    // MARK: Life cycles
    
    init(user:User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: 테마 바꼈을 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두운 테마
            view.backgroundColor = .black
            titleLabel.textColor = .white
            configureTest()
        }else {
            // 밝은 테마
            view.backgroundColor = .white
            titleLabel.textColor = .black
            configureTest()
        }
    }
    
    // MARK: Helpers
    
    func configureTest(){
        guard let test = self.test else { return }
        titleLabel.text = test.title
        numberOneTextLabel.text = test.questionOne
        numberTwoTextLabel.text = test.questionTwo
        numberThreeTextLabel.text = test.questionThree
        numberFourTextLabel.text = test.questionFour
        
        navigationItem.title = String(test.num)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            switch test.answer {
                case 1:
                    numberOneTextLabel.textColor = .tinderColor
                    numberOneLabel.textColor = .tinderColor
                    numberTwoLabel.textColor = .white
                    numberTwoTextLabel.textColor = .white
                    numberThreeTextLabel.textColor = .white
                    numberThreeLabel.textColor = .white
                    numberFourLabel.textColor = .white
                    numberFourTextLabel.textColor = .white
                case 2:
                    
                    numberOneTextLabel.textColor = .white
                    numberOneLabel.textColor = .white
                    numberTwoLabel.textColor = .tinderColor
                    numberTwoTextLabel.textColor = .tinderColor
                    numberThreeTextLabel.textColor = .white
                    numberThreeLabel.textColor = .white
                    numberFourLabel.textColor = .white
                    numberFourTextLabel.textColor = .white
            
                case 3:
                    numberOneTextLabel.textColor = .white
                    numberOneLabel.textColor = .white
                    numberTwoLabel.textColor = .white
                    numberTwoTextLabel.textColor = .white
                    numberThreeTextLabel.textColor = .tinderColor
                    numberThreeLabel.textColor = .tinderColor
                    numberFourLabel.textColor = .white
                    numberFourTextLabel.textColor = .white
                case 4:
                    numberOneTextLabel.textColor = .white
                    numberOneLabel.textColor = .white
                    numberTwoLabel.textColor = .white
                    numberTwoTextLabel.textColor = .white
                    numberThreeTextLabel.textColor = .white
                    numberThreeLabel.textColor = .white
                    numberFourLabel.textColor = .tinderColor
                    numberFourTextLabel.textColor = .tinderColor
                default:
                    print("nothing")
                }
        }else {
            switch test.answer {
                case 1:
                    numberOneTextLabel.textColor = .tinderColor
                    numberOneLabel.textColor = .tinderColor
                    numberTwoLabel.textColor = .black
                    numberTwoTextLabel.textColor = .black
                    numberThreeTextLabel.textColor = .black
                    numberThreeLabel.textColor = .black
                    numberFourLabel.textColor = .black
                    numberFourTextLabel.textColor = .black
                case 2:
                    
                    numberOneTextLabel.textColor = .black
                    numberOneLabel.textColor = .black
                    numberTwoLabel.textColor = .tinderColor
                    numberTwoTextLabel.textColor = .tinderColor
                    numberThreeTextLabel.textColor = .black
                    numberThreeLabel.textColor = .black
                    numberFourLabel.textColor = .black
                    numberFourTextLabel.textColor = .black
            
                case 3:
                    numberOneTextLabel.textColor = .black
                    numberOneLabel.textColor = .black
                    numberTwoLabel.textColor = .black
                    numberTwoTextLabel.textColor = .black
                    numberThreeTextLabel.textColor = .tinderColor
                    numberThreeLabel.textColor = .tinderColor
                    numberFourLabel.textColor = .black
                    numberFourTextLabel.textColor = .black
                case 4:
                    numberOneTextLabel.textColor = .black
                    numberOneLabel.textColor = .black
                    numberTwoLabel.textColor = .black
                    numberTwoTextLabel.textColor = .black
                    numberThreeTextLabel.textColor = .black
                    numberThreeLabel.textColor = .black
                    numberFourLabel.textColor = .tinderColor
                    numberFourTextLabel.textColor = .tinderColor
                default:
                    print("nothing")
                }
        }
        
        
        
        
        if test.num == 1 {
            prevButton.isHidden = true
            nextButton.isHidden = false
        }else if test.num == 10 {
            prevButton.isHidden = false
            nextButton.isHidden = true
        }else {
            prevButton.isHidden = false
            nextButton.isHidden = false
        }
        
        
        let font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        
        let titleLabelFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: test.title, width: Int(view.frame.width) - 40, font: font)
        let questionOneFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionOne, width: Int(view.frame.width) - 48, font: font)
        let questionTwoFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionTwo, width: Int(view.frame.width) - 48, font: font)
        let questionThreeFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionThree, width: Int(view.frame.width) - 48, font: font)
        let questionFourFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: test.questionFour, width: Int(view.frame.width) - 48, font: font)
        
        let height = 50 + 30 + 15 + 15 + 15 + 50 + 50 + titleLabelFrame.height + questionOneFrame.height + questionTwoFrame.height + questionThreeFrame.height + questionFourFrame.height
        
        scrollView.contentSize.height = height
        
    }
    
    // MARK: APIs
    func fetchTest(num:Int){
        DispatchQueue.main.async {
            LoadingShimmer.startCovering(self.view, with: nil)
        }
        TestService.shared.fetchTestWithNumAndUserId(userId: user.id, num: num) { (error, test) in
            LoadingShimmer.stopCovering(self.view)
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.test = test!
            }
        }
    }
    
    // MARK: Selectors
    
    @objc func nextButtonTapped(){
        guard let test = self.test else { return }
        fetchTest(num: test.num + 1)
    }
    
    @objc func prevButtonTapped(){
        guard let test = self.test else { return }
        fetchTest(num: test.num - 1)
    }
    
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: configures
    
    func configure(){
        fetchTest(num: 1)
        configureUI()
        configureNavigationBar()
    }
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        navigationItem.title = "1"
        guard let font = UIFont(name: "BMJUAOTF", size: 20) else { return }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.font: font
        ]
        
    }
    
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
        
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(numberOneLabel)
        numberOneLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOneLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        numberOneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        scrollView.addSubview(numberOneTextLabel)
        numberOneTextLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOneTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        numberOneTextLabel.leftAnchor.constraint(equalTo: numberOneLabel.rightAnchor, constant: 6).isActive = true
        numberOneTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(numberTwoLabel)
        numberTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        numberTwoLabel.topAnchor.constraint(equalTo: numberOneTextLabel.bottomAnchor, constant: 15).isActive = true
        numberTwoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        scrollView.addSubview(numberTwoTextLabel)
        numberTwoTextLabel.translatesAutoresizingMaskIntoConstraints = false
        numberTwoTextLabel.topAnchor.constraint(equalTo: numberOneTextLabel.bottomAnchor, constant: 15).isActive = true
        numberTwoTextLabel.leftAnchor.constraint(equalTo: numberTwoLabel.rightAnchor, constant: 6).isActive = true
        numberTwoTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(numberThreeLabel)
        numberThreeLabel.translatesAutoresizingMaskIntoConstraints = false
        numberThreeLabel.topAnchor.constraint(equalTo: numberTwoTextLabel.bottomAnchor, constant: 15).isActive = true
        numberThreeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        scrollView.addSubview(numberThreeTextLabel)
        numberThreeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        numberThreeTextLabel.topAnchor.constraint(equalTo: numberTwoTextLabel.bottomAnchor, constant: 15).isActive = true
        numberThreeTextLabel.leftAnchor.constraint(equalTo: numberThreeLabel.rightAnchor, constant: 6).isActive = true
        numberThreeTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(numberFourLabel)
        numberFourLabel.translatesAutoresizingMaskIntoConstraints = false
        numberFourLabel.topAnchor.constraint(equalTo: numberThreeTextLabel.bottomAnchor, constant: 15).isActive = true
        numberFourLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        scrollView.addSubview(numberFourTextLabel)
        numberFourTextLabel.translatesAutoresizingMaskIntoConstraints = false
        numberFourTextLabel.topAnchor.constraint(equalTo: numberThreeTextLabel.bottomAnchor, constant: 15).isActive = true
        numberFourTextLabel.leftAnchor.constraint(equalTo: numberFourLabel.rightAnchor, constant: 6).isActive = true
        numberFourTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(prevButton)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.topAnchor.constraint(equalTo: numberFourTextLabel.bottomAnchor, constant: 50).isActive = true
        prevButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        prevButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50).isActive = true
        
        scrollView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.topAnchor.constraint(equalTo: numberFourTextLabel.bottomAnchor, constant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50).isActive = true
        
    }
    

}
