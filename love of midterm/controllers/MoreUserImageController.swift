//
//  MoreUserImageController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MoreUserImageController: UICollectionViewController {
    
    
    
    // MARK: properties
    
    let backgroundImageIds:[String]
    
    // MARK: UIKits
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("이미지", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(.white, for: .normal)
        }else {
            button.setTitleColor(.black, for: .normal)
        }
        
        return button
    }()
    
    lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.text = "프로필 이미지 외의 사진이 없어요 😅"
        label.font = UIFont(name: "BMJUAOTF", size: 16)
        label.textColor = .lightGray
        return label
    }()
    
    
    // MARK: Life cycles
    
    init(backgroundImages:[String]) {
        self.backgroundImageIds = backgroundImages
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureNavigationBar()
        configureUI()
    }
    
    
    // MARK: 테마 바뀔때
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .dark {
            self.navigationController?.navigationBar.barStyle = .black
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.collectionView.backgroundColor = .black
        }else {
            self.navigationController?.navigationBar.barStyle = .default
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            self.collectionView.backgroundColor = .white
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbarController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showTabbarController()
    }
    
    // MARK: selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Configure
    
    func hideTabbarController(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbarController(){
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func configureUI(){
        
        if self.traitCollection.userInterfaceStyle == .dark {
            collectionView.backgroundColor = .black
        }else {
            collectionView.backgroundColor = .white
        }
        
        
        
        collectionView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 80).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        if backgroundImageIds.count != 0 {
            self.messageLabel.isHidden = true
        }
    }
    
    func configure(){
        collectionView.register(UserBackgroundImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return backgroundImageIds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserBackgroundImageCell
    
        // Configure the cell
        cell.backgroundImageId = backgroundImageIds[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
}

// MARK: Set collectionviewcell size and interspace
extension MoreUserImageController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: UserBackgroundCellDelegate

extension MoreUserImageController:UserBackgroumdImageCellDelegate {
    func presentOneUserBackgroundImageController(cell: UserBackgroundImageCell) {
    
        guard let imageUrl = cell.backgroundImageUrl else { return }
        
        let oneUserBackgroundImageVC = OneUserBackgroundImageController(imageUrlString:imageUrl)
        present(oneUserBackgroundImageVC, animated: true, completion: nil)
    }
}
