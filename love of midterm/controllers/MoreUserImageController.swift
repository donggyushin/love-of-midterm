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
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.setTitleColor(.tinderColor, for: .normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        return button
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
    
    // MARK: selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Configure
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func configureUI(){
        
        collectionView.backgroundColor = .white
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
