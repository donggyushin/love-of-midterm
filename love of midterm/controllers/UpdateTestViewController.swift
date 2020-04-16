//
//  UpdateTestViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/10.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import GrowingTextView
import LoadingShimmer

protocol UpdateTestViewControllerDelegate:class {
    func updateTest(cell:UpdateTestViewController)
}

class UpdateTestViewController: UIViewController {
    
    // MARK: Properties
    let test:Test
    var newAnswer:Int?
    weak var delegate:UpdateTestViewControllerDelegate?
    
    // MARK: UIKits
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("뒤로", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var titleTextView:GrowingTextView = {
        let tv = GrowingTextView()
        tv.maxLength = 225
        tv.minHeight = 70
        tv.maxHeight = 130
        tv.autocorrectionType = .no
        tv.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        tv.layer.cornerRadius = 4.0
        
        if self.traitCollection.userInterfaceStyle == .dark {
            tv.textColor = .white
            tv.backgroundColor = .black
        }else {
            tv.textColor = .black
            tv.backgroundColor = .white
        }
        
        return tv
    }()
    
    lazy var numberOneIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "1")
        let tap = UITapGestureRecognizer(target: self, action: #selector(questionOneTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var numberOneTextField:UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.textColor = .black

        return tf
    }()
    
    lazy var numberTwoIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "2")
        let tap = UITapGestureRecognizer(target: self, action: #selector(questionTwoTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var numberTwoTextField:UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.textColor = .black
        
        return tf
    }()
    
    lazy var numberThreeIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "3")
        let tap = UITapGestureRecognizer(target: self, action: #selector(questionThreeTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var numberThreeTextField:UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.textColor = .black
        
        return tf
    }()
    
    lazy var numberFourIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "4")
        let tap = UITapGestureRecognizer(target: self, action: #selector(questionFourTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var numberFourTextField:UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.textColor = .black
        
        return tf
    }()
    
    lazy var updateButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("문제변경", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 18)
        button.setTitleColor(UIColor.tinderColor, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(updateButtonTapped), for: UIControl.Event.touchUpInside)
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
        makeAllQuestionBlack()
        configure()
        self.hideKeyboardWhenTappedAround()
        
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
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        makeAllQuestionBlack()
        switch test.answer {
        case 1:
            numberOneIcon.image = numberOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberOneIcon.tintColor = .tinderColor
            numberOneTextField.textColor = .tinderColor
        case 2:
            numberTwoIcon.image = numberTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberTwoIcon.tintColor = .tinderColor
            numberTwoTextField.textColor = .tinderColor
        case 3:
            numberThreeIcon.image = numberThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberThreeIcon.tintColor = .tinderColor
            numberThreeTextField.textColor = .tinderColor
        case 4:
            numberFourIcon.image = numberFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberFourIcon.tintColor = .tinderColor
            numberFourTextField.textColor = .tinderColor
        default:
            print("nothing")
        }
        if previousTraitCollection.userInterfaceStyle == .light {
            titleTextView.backgroundColor = .black
            titleTextView.textColor = .white
            view.backgroundColor = .black
        }else {
            titleTextView.backgroundColor = .white
            titleTextView.textColor = .black
            view.backgroundColor = .white
        }
        
        
        
        
    }
    
    // MARK: Selectors
    
    @objc func updateButtonTapped(){
        guard let newAnswer = newAnswer,
            let newTitle = titleTextView.text,
            let newQuestionOne = numberOneTextField.text,
            let newQuestionTwo = numberTwoTextField.text,
            let newQuestionThree = numberThreeTextField.text,
            let newQuestionFour = numberFourTextField.text else { return }
        
        LoadingShimmer.startCovering(self.view, with: nil)
        
        TestService.shared.updateTest(testId: test.id, newAnswer: newAnswer, newTitle: newTitle, newQuestionOne: newQuestionOne, newQuestionTwo: newQuestionTwo, newQuestionThree: newQuestionThree, newQuestionFour: newQuestionFour) { (error) in
            LoadingShimmer.stopCovering(self.view)
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.delegate?.updateTest(cell: self)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func questionFourTapped(){
        makeAllQuestionBlack()
        numberFourIcon.image = numberFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        numberFourIcon.tintColor = .tinderColor
        numberFourTextField.textColor = .tinderColor
        
        newAnswer = 4
    }
    
    @objc func questionThreeTapped(){
        makeAllQuestionBlack()
        numberThreeIcon.image = numberThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        numberThreeIcon.tintColor = .tinderColor
        numberThreeTextField.textColor = .tinderColor
        
        newAnswer = 3
    }
    
    @objc func questionTwoTapped(){
        
        makeAllQuestionBlack()
        numberTwoIcon.image = numberTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        numberTwoIcon.tintColor = .tinderColor
        numberTwoTextField.textColor = .tinderColor
        
        newAnswer = 2
        
    }
    
    @objc func questionOneTapped(){
        makeAllQuestionBlack()
        numberOneIcon.image = numberOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        numberOneIcon.tintColor = .tinderColor
        numberOneTextField.textColor = .tinderColor
        
        newAnswer = 1
    }
    
    @objc func backbuttonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    
    func makeAllQuestionBlack(){
        
        if self.traitCollection.userInterfaceStyle == .dark {
            numberOneIcon.image = numberOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberOneIcon.tintColor = .white
            numberOneTextField.textColor = .white
            
            numberTwoIcon.image = numberTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberTwoIcon.tintColor = .white
            numberTwoTextField.textColor = .white
            
            numberThreeIcon.image = numberThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberThreeIcon.tintColor = .white
            numberThreeTextField.textColor = .white
            
            numberFourIcon.image = numberFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberFourIcon.tintColor = .white
            numberFourTextField.textColor = .white
        }else {
            numberOneIcon.image = numberOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberOneIcon.tintColor = .black
            numberOneTextField.textColor = .black
            
            numberTwoIcon.image = numberTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberTwoIcon.tintColor = .black
            numberTwoTextField.textColor = .black
            
            numberThreeIcon.image = numberThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberThreeIcon.tintColor = .black
            numberThreeTextField.textColor = .black
            
            numberFourIcon.image = numberFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberFourIcon.tintColor = .black
            numberFourTextField.textColor = .black
        }
        
    }
    
    func setForTest(){
        titleTextView.text = test.title
        numberOneTextField.text = test.questionOne
        numberTwoTextField.text = test.questionTwo
        numberThreeTextField.text = test.questionThree
        numberFourTextField.text = test.questionFour
        
        newAnswer = test.answer
        
        switch test.answer {
        case 1:
            numberOneIcon.image = numberOneIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberOneIcon.tintColor = .tinderColor
            numberOneTextField.textColor = .tinderColor
        case 2:
            numberTwoIcon.image = numberTwoIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberTwoIcon.tintColor = .tinderColor
            numberTwoTextField.textColor = .tinderColor
        case 3:
            numberThreeIcon.image = numberThreeIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberThreeIcon.tintColor = .tinderColor
            numberThreeTextField.textColor = .tinderColor
        case 4:
            numberFourIcon.image = numberFourIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            numberFourIcon.tintColor = .tinderColor
            numberFourTextField.textColor = .tinderColor
        default:
            print("nothing")
        }
        
        
        
        
    }
    
    // MARK: configures
    func configure(){
        setForTest()
        configureUI()
        
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
        
        
        scrollView.addSubview(titleTextView)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        titleTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        scrollView.addSubview(numberOneIcon)
        numberOneIcon.translatesAutoresizingMaskIntoConstraints = false
        numberOneIcon.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 50).isActive = true
        numberOneIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        numberOneIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
        numberOneIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        scrollView.addSubview(numberOneTextField)
        numberOneTextField.translatesAutoresizingMaskIntoConstraints = false
        numberOneTextField.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 50).isActive = true
        numberOneTextField.leftAnchor.constraint(equalTo: numberOneIcon.rightAnchor, constant: 15).isActive = true
        numberOneTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        scrollView.addSubview(numberTwoIcon)
        numberTwoIcon.translatesAutoresizingMaskIntoConstraints = false
        numberTwoIcon.topAnchor.constraint(equalTo: numberOneTextField.bottomAnchor, constant: 25).isActive = true
        numberTwoIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        numberTwoIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
        numberTwoIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        scrollView.addSubview(numberTwoTextField)
        numberTwoTextField.translatesAutoresizingMaskIntoConstraints = false
        numberTwoTextField.topAnchor.constraint(equalTo: numberOneTextField.bottomAnchor, constant: 25).isActive = true
        numberTwoTextField.leftAnchor.constraint(equalTo: numberTwoIcon.rightAnchor, constant: 15).isActive = true
        numberTwoTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        scrollView.addSubview(numberThreeIcon)
        numberThreeIcon.translatesAutoresizingMaskIntoConstraints = false
        numberThreeIcon.topAnchor.constraint(equalTo: numberTwoTextField.bottomAnchor, constant: 25).isActive = true
        numberThreeIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        numberThreeIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
        numberThreeIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        scrollView.addSubview(numberThreeTextField)
        numberThreeTextField.translatesAutoresizingMaskIntoConstraints = false
        numberThreeTextField.topAnchor.constraint(equalTo: numberTwoTextField.bottomAnchor, constant: 25).isActive = true
        numberThreeTextField.leftAnchor.constraint(equalTo: numberThreeIcon.rightAnchor, constant: 15).isActive = true
        numberThreeTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        scrollView.addSubview(numberFourIcon)
        numberFourIcon.translatesAutoresizingMaskIntoConstraints = false
        numberFourIcon.topAnchor.constraint(equalTo: numberThreeTextField.bottomAnchor, constant: 25).isActive = true
        numberFourIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        numberFourIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
        numberFourIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        scrollView.addSubview(numberFourTextField)
        numberFourTextField.translatesAutoresizingMaskIntoConstraints = false
        numberFourTextField.topAnchor.constraint(equalTo: numberThreeTextField.bottomAnchor, constant: 25).isActive = true
        numberFourTextField.leftAnchor.constraint(equalTo: numberFourIcon.rightAnchor, constant: 15).isActive = true
        numberFourTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        scrollView.addSubview(updateButton)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.topAnchor.constraint(equalTo: numberFourTextField.bottomAnchor, constant: 50).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
