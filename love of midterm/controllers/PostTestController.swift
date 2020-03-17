//
//  PostTestController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/17.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import GrowingTextView

class PostTestController: UIViewController {
    
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
        label.text = "1 / 10"
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
    
    // MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: configure
    
    func configure(){
        view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        configureUI()
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
        
    }
    
}
