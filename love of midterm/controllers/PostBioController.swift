//
//  PostBioController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/18.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import GrowingTextView
import LoadingShimmer

protocol PostBioControllerDelgate:class {
    func redirectToMainApplication(VC:PostBioController)
}

class PostBioController: UIViewController {
    
    
    weak var delegate:PostBioControllerDelgate?
    
    // MARK: UIKits
    lazy var logoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.heightAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
        iv.image = #imageLiteral(resourceName: "loveOfMidterm")
        return iv
    }()
    
    lazy var congraturationLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 17)
        label.text = "축하합니다!"
        return label
    }()
    
    lazy var bioGrowingTextView:GrowingTextView = {
        let tv = GrowingTextView()
        tv.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        tv.backgroundColor = .systemGroupedBackground
        tv.layer.cornerRadius = 8
        tv.placeholder = "간략한 자기소개를 해주세요!"
        tv.minHeight = 100
        tv.maxHeight = 100
        tv.maxLength = 150
        tv.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.75).isActive = true 
        tv.autocorrectionType = .no
        
        if self.traitCollection.userInterfaceStyle == .dark {
            tv.textColor = .white
            tv.backgroundColor = .black
        }else {
            tv.textColor = .black
            tv.backgroundColor = .white
        }
        
        
        return tv
    }()
    
    lazy var startButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("시작하기", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .tinderColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 17)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Life cycles
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: selectors
    
    @objc func startButtonTapped(){
        guard let bio = bioGrowingTextView.text else { return }
        LoadingShimmer.startCovering(self.view, with: nil)
        // 유저에게 bio 업데이트하고
        UserService.shared.postBio(bio: bio) { (error) in
            LoadingShimmer.stopCovering(self.view)
            if let error = error {
//                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
                
                print(error.localizedDescription)
                // 현재 팝업창을 내린다
                self.dismiss(animated: true, completion: nil)
                // 부모 팝업창을 내린다
                self.delegate?.redirectToMainApplication(VC: self)
                
            }else {
                // RootController 의 user 데이터베이스에서 다시 한 번 페치하기
                RootViewController.rootViewController.fetchUser()
                
                
                // 현재 팝업창을 내린다
                self.dismiss(animated: true, completion: nil)
                // 부모 팝업창을 내린다
                self.delegate?.redirectToMainApplication(VC: self)
                
                
            }
        }
        
        
        
    }
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두울 때
            view.backgroundColor = .black
            bioGrowingTextView.backgroundColor = .black
            bioGrowingTextView.textColor = .white
        }else {
            // 밝을 때
            view.backgroundColor = .white
            bioGrowingTextView.backgroundColor = .white
            bioGrowingTextView.textColor = .black
        }
    }
    
    
    // MARK: configures
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
        
        
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        view.addSubview(congraturationLabel)
        congraturationLabel.translatesAutoresizingMaskIntoConstraints = false
        congraturationLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        congraturationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        view.addSubview(bioGrowingTextView)
        bioGrowingTextView.translatesAutoresizingMaskIntoConstraints = false
        bioGrowingTextView.topAnchor.constraint(equalTo: congraturationLabel.bottomAnchor, constant: 20).isActive = true
        bioGrowingTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
        
    }
    
}
