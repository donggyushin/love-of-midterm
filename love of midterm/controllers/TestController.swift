//
//  TestController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/21.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

protocol TestControllerDelegate:class {
    func popupResultController(view:TestController)
    func popupResultControllerTypeTwo(view:TestController)
}

class TestController: UIViewController {
    
    // MARK: properties
    var currentIndex = 1
    var selectedAnswer:Int?
    let user:User
    var test:Test? {
        didSet {
            configureTest()
        }
    }
    var correctCount = 0
    
    weak var delegate:TestControllerDelegate?
    
    // MARK: UIKits
    
    lazy var closeButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("포기할래요", for: .normal)
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var indexLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 14)
        label.text = "1/10"
        return label
    }()
    
    lazy var questionIcon:UILabel = {
        let label = UILabel()
        label.text = "Q."
        label.textColor = .tinderColor
        label.font = UIFont(name: "BMJUAOTF", size: 20)
        return label
    }()
    
    lazy var questionTitleLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        return label
    }()

    
    lazy var optionOneIcon:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.image = #imageLiteral(resourceName: "1")
        return iv
    }()
    
    lazy var optionOneLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(oneTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var optionTwoIcon:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.image = #imageLiteral(resourceName: "2")
        return iv
    }()
    
    lazy var optionTwoLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(twoTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var optionThreeIcon:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.image = #imageLiteral(resourceName: "3")
        return iv
    }()
    
    lazy var optionThreeLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(threeTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var optionFourIcon:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.image = #imageLiteral(resourceName: "4")
        return iv
    }()
    
    lazy var optionFourLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(fourTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var submitButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("제출하기", for: .normal)
        button.setTitleColor(.tinderColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var answerMark:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 160)
        label.text = "o"
        label.textColor = UIColor.facebookBlue
        label.isHidden = true
        return label
    }()
    
    lazy var wrongMark:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 160)
        label.text = "x"
        label.textColor = UIColor.tinderColor
        label.isHidden = true
        return label
    }()
    
    
    // MARK: Life cycle
    
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
        updateTry()
        
    }
    
    // MARK: APIs
    
    func updateTry(){
        TryService.shared.tryToHaveAConversation(to: user.id)
    }
    
    func fetchTest(){
        TestService.shared.fetchTestWithNumAndUserId(userId: user.id, num: currentIndex) { (error, test) in
            self.submitButton.isEnabled = true
            self.answerMark.isHidden = true
            self.wrongMark.isHidden = true
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.test = test!
            }
        }
    }
    
    // MARK: selectors
    
    @objc func submitButtonTapped(){
        guard let selectedAnswer = self.selectedAnswer else { return }
        guard let test = self.test else { return }
        self.submitButton.isEnabled = false
        self.currentIndex += 1
        
        if selectedAnswer == test.answer {
            // 정답일때
            self.answerMark.isHidden = false
            self.correctCount += 1
            
            if self.currentIndex == 11 {
                print("맞춘 정답 수: ", self.correctCount)
                
                if self.correctCount > 6 {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.popupResultController(view: self)
                }else {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.popupResultControllerTypeTwo(view: self)
                }
                
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { 
                    // 다음 문제 호출
                    self.fetchTest()
                    
                }
            }
            
        }else {
            // 오답일때
            self.wrongMark.isHidden = false
            
            if self.currentIndex == 11 {
                print("맞춘 정답 수: ", self.correctCount)
                if self.correctCount > 6 {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.popupResultController(view: self)
                }else {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.popupResultControllerTypeTwo(view: self)
                }
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    
                    // 다음 문제 호출
                    self.fetchTest()
                }
            }
            
        }
        
    }
    
    @objc func closeButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func oneTapped(){
        
        self.selectedAnswer = 1
        
        optionOneIcon.image = optionOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionOneIcon.tintColor = UIColor.tinderColor
        optionOneLabel.textColor = UIColor.tinderColor
        
        optionTwoIcon.image = optionTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionTwoIcon.tintColor = UIColor.black
        optionTwoLabel.textColor = UIColor.black
        
        optionThreeIcon.image = optionThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionThreeIcon.tintColor = UIColor.black
        optionThreeLabel.textColor = UIColor.black
        
        optionFourIcon.image = optionFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionFourIcon.tintColor = UIColor.black
        optionFourLabel.textColor = UIColor.black
    }
    
    
    @objc func twoTapped(){
        
        self.selectedAnswer = 2
        
        optionTwoIcon.image = optionTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionTwoIcon.tintColor = UIColor.tinderColor
        optionTwoLabel.textColor = UIColor.tinderColor
        
        optionOneIcon.image = optionOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionOneIcon.tintColor = UIColor.black
        optionOneLabel.textColor = UIColor.black
        
        optionThreeIcon.image = optionThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionThreeIcon.tintColor = UIColor.black
        optionThreeLabel.textColor = UIColor.black
        
        optionFourIcon.image = optionFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionFourIcon.tintColor = UIColor.black
        optionFourLabel.textColor = UIColor.black
    }
    
    @objc func threeTapped(){
        
        self.selectedAnswer = 3
        
        optionThreeIcon.image = optionThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionThreeIcon.tintColor = UIColor.tinderColor
        optionThreeLabel.textColor = UIColor.tinderColor
        
        optionOneIcon.image = optionOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionOneIcon.tintColor = UIColor.black
        optionOneLabel.textColor = UIColor.black
        
        optionTwoIcon.image = optionTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionTwoIcon.tintColor = UIColor.black
        optionTwoLabel.textColor = UIColor.black
        
        optionFourIcon.image = optionFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionFourIcon.tintColor = UIColor.black
        optionFourLabel.textColor = UIColor.black
    }
    
    @objc func fourTapped(){
        
        self.selectedAnswer = 4
        
        optionFourIcon.image = optionFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionFourIcon.tintColor = UIColor.tinderColor
        optionFourLabel.textColor = UIColor.tinderColor
        
        optionOneIcon.image = optionOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionOneIcon.tintColor = UIColor.black
        optionOneLabel.textColor = UIColor.black
        
        optionTwoIcon.image = optionTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionTwoIcon.tintColor = UIColor.black
        optionTwoLabel.textColor = UIColor.black
        
        optionThreeIcon.image = optionThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionThreeIcon.tintColor = UIColor.black
        optionThreeLabel.textColor = UIColor.black
    }
    
    
    
    
    // MARK: configure
    
    func configureTest(){
        guard let test = test else { return }
        
        self.selectedAnswer = nil
        self.indexLabel.text = "\(currentIndex)/10"
        
        questionTitleLabel.text = test.title
        optionOneLabel.text = test.questionOne
        optionTwoLabel.text = test.questionTwo
        optionThreeLabel.text = test.questionThree
        optionFourLabel.text = test.questionFour
        
        
        optionThreeIcon.image = optionThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionThreeIcon.tintColor = UIColor.black
        optionThreeLabel.textColor = UIColor.black
        
        optionOneIcon.image = optionOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionOneIcon.tintColor = UIColor.black
        optionOneLabel.textColor = UIColor.black
        
        optionTwoIcon.image = optionTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionTwoIcon.tintColor = UIColor.black
        optionTwoLabel.textColor = UIColor.black
        
        optionFourIcon.image = optionFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        optionFourIcon.tintColor = UIColor.black
        optionFourLabel.textColor = UIColor.black
    }
    
    func configure(){
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        
        configureUI()
        fetchTest()
    }
    
    func configureUI(){
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        
        
        view.addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
        indexLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(questionIcon)
        questionIcon.translatesAutoresizingMaskIntoConstraints = false
        questionIcon.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 14).isActive = true
        questionIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true
        
        view.addSubview(questionTitleLabel)
        questionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        questionTitleLabel.topAnchor.constraint(equalTo: indexLabel.bottomAnchor, constant: 18).isActive = true
        questionTitleLabel.leftAnchor.constraint(equalTo: questionIcon.rightAnchor, constant: 5).isActive = true
        questionTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        
        view.addSubview(optionOneIcon)
        optionOneIcon.translatesAutoresizingMaskIntoConstraints = false
        optionOneIcon.topAnchor.constraint(equalTo: questionIcon.bottomAnchor, constant: 30).isActive = true
        optionOneIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true
        
        view.addSubview(optionOneLabel)
        optionOneLabel.translatesAutoresizingMaskIntoConstraints = false
        optionOneLabel.topAnchor.constraint(equalTo: questionIcon.bottomAnchor, constant: 34).isActive = true
        optionOneLabel.leftAnchor.constraint(equalTo: optionOneIcon.rightAnchor, constant: 5).isActive = true
        optionOneLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        view.addSubview(optionTwoIcon)
        optionTwoIcon.translatesAutoresizingMaskIntoConstraints = false
        optionTwoIcon.topAnchor.constraint(equalTo: optionOneIcon.bottomAnchor, constant: 20).isActive = true
        optionTwoIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true
        
        view.addSubview(optionTwoLabel)
        optionTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        optionTwoLabel.topAnchor.constraint(equalTo: optionOneIcon.bottomAnchor, constant: 24).isActive = true
        optionTwoLabel.leftAnchor.constraint(equalTo: optionTwoIcon.rightAnchor, constant: 5).isActive = true
        optionTwoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        view.addSubview(optionThreeIcon)
        optionThreeIcon.translatesAutoresizingMaskIntoConstraints = false
        optionThreeIcon.topAnchor.constraint(equalTo: optionTwoIcon.bottomAnchor, constant: 20).isActive = true
        optionThreeIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true
        
        view.addSubview(optionThreeLabel)
        optionThreeLabel.translatesAutoresizingMaskIntoConstraints = false
        optionThreeLabel.topAnchor.constraint(equalTo: optionTwoIcon.bottomAnchor, constant: 24).isActive = true
        optionThreeLabel.leftAnchor.constraint(equalTo: optionThreeIcon.rightAnchor, constant: 5).isActive = true
        optionThreeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(optionFourIcon)
        optionFourIcon.translatesAutoresizingMaskIntoConstraints = false
        optionFourIcon.topAnchor.constraint(equalTo: optionThreeIcon.bottomAnchor, constant: 20).isActive = true
        optionFourIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true
        
        view.addSubview(optionFourLabel)
        optionFourLabel.translatesAutoresizingMaskIntoConstraints = false
        optionFourLabel.topAnchor.constraint(equalTo: optionThreeIcon.bottomAnchor, constant: 24).isActive = true
        optionFourLabel.leftAnchor.constraint(equalTo: optionFourIcon.rightAnchor, constant: 5).isActive = true
        optionFourLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: optionFourIcon.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(answerMark)
        answerMark.translatesAutoresizingMaskIntoConstraints = false
        answerMark.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        answerMark.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
        view.addSubview(wrongMark)
        wrongMark.translatesAutoresizingMaskIntoConstraints = false
        wrongMark.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrongMark.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
    }

}
