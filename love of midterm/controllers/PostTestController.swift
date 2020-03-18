//
//  PostTestController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/17.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import GrowingTextView
import LoadingShimmer
import PopupDialog

class PostTestController: UIViewController {
    
    // MARK: properties
    
    var currentIndex = 1
    
    // MARK: UIKits
    
    lazy var customNavigationBar:UIView = {
        let view = UIView()
        view.backgroundColor = .tinderColor
        return view
    }()
    
    lazy var logoLabel:UILabel = {
        let label = UILabel()
        label.text = "중간의 연애"
        label.textColor = .white
        label.font = UIFont(name: "BMJUAOTF", size: 23)
        return label
    }()
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize.height = 1000
        return sv
    }()
    
    
    lazy var indexLabel:UILabel = {
        let label = UILabel()
        label.text = "\(self.currentIndex) / 10"
        label.font = UIFont(name: "BMJUAOTF", size: 17)
        return label
    }()
    
    lazy var pencilIconImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.image = #imageLiteral(resourceName: "pencil")
        return iv
    }()
    
    lazy var questionTitleGrowingTextView:GrowingTextView = {
        let tv = GrowingTextView()
        tv.font = UIFont(name: "BMJUAOTF", size: 15)
        tv.backgroundColor = .systemGroupedBackground
        tv.layer.cornerRadius = 8
        tv.placeholder = "문제를 입력해주세요."
        tv.minHeight = 50
        tv.maxLength = 150
        tv.autocorrectionType = .no
        return tv
    }()
    
    lazy var numberOneLabel:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.image = #imageLiteral(resourceName: "1")
        return iv
    }()
    
    lazy var optionOneGrowingLabel:GrowingTextView = {
        let tv = GrowingTextView()
        tv.font = UIFont(name: "BMJUAOTF", size: 15)
        tv.backgroundColor = .systemGroupedBackground
        tv.layer.cornerRadius = 8
        tv.placeholder = "1번 보기를 입력해주세요."
        tv.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        tv.minHeight = 30
        tv.maxLength = 150
        tv.autocorrectionType = .no
        return tv
    }()
    
    lazy var numberTwoLabel:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.image = #imageLiteral(resourceName: "2")
        return iv
    }()
    
    lazy var optionTwoGrowingLabel:GrowingTextView = {
        let tv = GrowingTextView()
        tv.font = UIFont(name: "BMJUAOTF", size: 15)
        tv.backgroundColor = .systemGroupedBackground
        tv.layer.cornerRadius = 8
        tv.placeholder = "2번 보기를 입력해주세요."
        tv.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        tv.minHeight = 30
        tv.maxLength = 150
        tv.autocorrectionType = .no
        return tv
    }()
    
    lazy var numberThreeLabel:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.image = #imageLiteral(resourceName: "3")
        return iv
    }()
    
    lazy var optionThreeGrowingLabel:GrowingTextView = {
        let tv = GrowingTextView()
        tv.font = UIFont(name: "BMJUAOTF", size: 15)
        tv.backgroundColor = .systemGroupedBackground
        tv.layer.cornerRadius = 8
        tv.placeholder = "3번 보기를 입력해주세요."
        tv.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        tv.minHeight = 30
        tv.maxLength = 150
        tv.autocorrectionType = .no
        return tv
    }()
    
    lazy var numberFourLabel:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.image = #imageLiteral(resourceName: "4")
        return iv
    }()
    
    lazy var optionFourGrowingLabel:GrowingTextView = {
        let tv = GrowingTextView()
        tv.font = UIFont(name: "BMJUAOTF", size: 15)
        tv.backgroundColor = .systemGroupedBackground
        tv.layer.cornerRadius = 8
        tv.placeholder = "4번 보기를 입력해주세요."
        tv.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        tv.minHeight = 30
        tv.maxLength = 150
        tv.autocorrectionType = .no
        return tv
    }()
    
    lazy var answerLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 17)
        label.text = "정답 :"
        return label
    }()
    
    lazy var answerTextField:UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .systemGroupedBackground
        tf.layer.cornerRadius = 8
        tf.widthAnchor.constraint(equalToConstant: 50).isActive = true
        tf.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        return tf
    }()
    
    lazy var submitButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .tinderColor
        button.setTitle("출제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 17)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: helpers
    
    func popPostBioController(){
        let popup = PopupDialog(viewController: PostBioController())
        self.present(popup, animated: true, completion: nil)
    }
    
    // MARK: APIs
    
    func fetchTestIfUserAlreadyHas(){
        TestService.shared.fetchTestWithNum(num: self.currentIndex) { (error, test) in
            if let error = error {
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                guard let test = test else { return }
                self.questionTitleGrowingTextView.text = test.title
                self.optionOneGrowingLabel.text = test.questionOne
                self.optionTwoGrowingLabel.text = test.questionTwo
                self.optionThreeGrowingLabel.text = test.questionThree
                self.optionFourGrowingLabel.text = test.questionFour
                self.answerTextField.text = "\(test.answer)"
                
            }
        }
    }
    
    // MARK: Selectors
    @objc func submitButtonTapped(){
        
        guard let title = questionTitleGrowingTextView.text else { return }
        guard let questionOne = optionOneGrowingLabel.text else { return }
        guard let questionTwo = optionTwoGrowingLabel.text else { return }
        guard let questionThree = optionThreeGrowingLabel.text else { return }
        guard let questionFour = optionFourGrowingLabel.text else { return }
        guard let answerString = answerTextField.text else {
            self.popupDialog(title: "경고", message: "정답을 제대로 표기하지 않으셨습니다. 정답을 꼭 표기해주세요.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            return }
        guard let answer = Int(answerString) else {
            self.popupDialog(title: "경고", message: "정답을 제대로 표기하지 않으셨습니다. 정답을 꼭 표기해주세요.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            return }
        
        if title == "" || questionOne == "" || questionTwo == "" || questionThree == "" || questionFour == "" {
            self.popupDialog(title: "경고", message: "문제와 정답을 모두 입력해주세요.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            return
        }
        
        if answer < 1 || answer > 4 {
            self.popupDialog(title: "경고", message: "정답은 꼭 1부터 4까지만 입력해주세요.", image: #imageLiteral(resourceName: "loveOfMidterm"))
            return
        }
        
        
        LoadingShimmer.startCovering(self.view, with: nil)
        
        TestService.shared.postNewTest(num: self.currentIndex, title: title, questionOne: questionOne, questionTwo: questionTwo, questionThree: questionThree, questionFour: questionFour, answer: answer) { (error) in
            if let error = error {
                LoadingShimmer.stopCovering(self.view)
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다.", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                
                
                self.questionTitleGrowingTextView.text = ""
                self.optionOneGrowingLabel.text = ""
                self.optionTwoGrowingLabel.text = ""
                self.optionThreeGrowingLabel.text = ""
                self.optionFourGrowingLabel.text = ""
                self.answerTextField.text = ""
                self.currentIndex += 1
                
                self.indexLabel.text = "\(self.currentIndex) / 10"
                
                LoadingShimmer.stopCovering(self.view)
                
                self.fetchTestIfUserAlreadyHas()
                
                
                if self.currentIndex == 11 {
                    self.popPostBioController()
                }
            }
        }
        
        
        
    }
    
    
    // MARK: configure
    
    func configure(){
        view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        configureUI()
        fetchTestIfUserAlreadyHas()
    }
    
    func configureUI(){
        
        view.addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        customNavigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        customNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        customNavigationBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -15).isActive = true
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        indexLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        scrollView.addSubview(pencilIconImageView)
        pencilIconImageView.translatesAutoresizingMaskIntoConstraints = false
        pencilIconImageView.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 40).isActive = true
        pencilIconImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        
        scrollView.addSubview(questionTitleGrowingTextView)
        questionTitleGrowingTextView.translatesAutoresizingMaskIntoConstraints = false
        questionTitleGrowingTextView.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 40).isActive = true
        questionTitleGrowingTextView.leftAnchor.constraint(equalTo: pencilIconImageView.rightAnchor, constant: 10).isActive = true
        questionTitleGrowingTextView.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        
        
        scrollView.addSubview(numberOneLabel)
        numberOneLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOneLabel.topAnchor.constraint(equalTo: questionTitleGrowingTextView.bottomAnchor, constant: 50).isActive = true
        numberOneLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        scrollView.addSubview(optionOneGrowingLabel)
        optionOneGrowingLabel.translatesAutoresizingMaskIntoConstraints = false
        optionOneGrowingLabel.topAnchor.constraint(equalTo: questionTitleGrowingTextView.bottomAnchor, constant: 48).isActive = true
        optionOneGrowingLabel.leftAnchor.constraint(equalTo: numberOneLabel.rightAnchor, constant: 25).isActive = true
        
        
        scrollView.addSubview(numberTwoLabel)
        numberTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        numberTwoLabel.topAnchor.constraint(equalTo: optionOneGrowingLabel.bottomAnchor, constant: 20).isActive = true
        numberTwoLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        scrollView.addSubview(optionTwoGrowingLabel)
        optionTwoGrowingLabel.translatesAutoresizingMaskIntoConstraints = false
        optionTwoGrowingLabel.topAnchor.constraint(equalTo: optionOneGrowingLabel.bottomAnchor, constant: 18).isActive = true
        optionTwoGrowingLabel.leftAnchor.constraint(equalTo: numberOneLabel.rightAnchor, constant: 25).isActive = true
        
        
        scrollView.addSubview(numberThreeLabel)
        numberThreeLabel.translatesAutoresizingMaskIntoConstraints = false
        numberThreeLabel.topAnchor.constraint(equalTo: optionTwoGrowingLabel.bottomAnchor, constant: 20).isActive = true
        numberThreeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        scrollView.addSubview(optionThreeGrowingLabel)
        optionThreeGrowingLabel.translatesAutoresizingMaskIntoConstraints = false
        optionThreeGrowingLabel.topAnchor.constraint(equalTo: optionTwoGrowingLabel.bottomAnchor, constant: 18).isActive = true
        optionThreeGrowingLabel.leftAnchor.constraint(equalTo: numberOneLabel.rightAnchor, constant: 25).isActive = true
        
        scrollView.addSubview(numberFourLabel)
        numberFourLabel.translatesAutoresizingMaskIntoConstraints = false
        numberFourLabel.topAnchor.constraint(equalTo: optionThreeGrowingLabel.bottomAnchor, constant: 20).isActive = true
        numberFourLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        scrollView.addSubview(optionFourGrowingLabel)
        optionFourGrowingLabel.translatesAutoresizingMaskIntoConstraints = false
        optionFourGrowingLabel.topAnchor.constraint(equalTo: optionThreeGrowingLabel.bottomAnchor, constant: 18).isActive = true
        optionFourGrowingLabel.leftAnchor.constraint(equalTo: numberOneLabel.rightAnchor, constant: 25).isActive = true
        
        scrollView.addSubview(answerLabel)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40).isActive = true
        answerLabel.topAnchor.constraint(equalTo: optionFourGrowingLabel.bottomAnchor, constant: 50).isActive = true
        
        scrollView.addSubview(answerTextField)
        answerTextField.translatesAutoresizingMaskIntoConstraints = false
        answerTextField.topAnchor.constraint(equalTo: optionFourGrowingLabel.bottomAnchor, constant: 46).isActive = true
        answerTextField.leftAnchor.constraint(equalTo: answerLabel.rightAnchor, constant: 13).isActive = true
        
        scrollView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 50).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
}
