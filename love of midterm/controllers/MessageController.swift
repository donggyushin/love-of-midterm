//
//  MessageController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MessageController: UICollectionViewController {
    
    // MARK: properties
    var chats = [Chat]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var me:User?
    
    
    // MARK: life cycles
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 다크 테마일때
            self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white
            ]
            
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = .black
            collectionView.backgroundColor = .black
        }else {
            // 화이트 테마일때
            self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.black
            ]
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.barTintColor = .white
            collectionView.backgroundColor = .white
        }
    }
    
    // MARK: configures
    
    func configure(){
        if self.traitCollection.userInterfaceStyle == .dark {
            // 어두운 테마일때
            collectionView.backgroundColor = .black
        }else {
            // 밝은 테마일때
            collectionView.backgroundColor = .white
        }
        
        configureNavigationBar()
        self.collectionView!.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    func configureNavigationBar(){
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.white
            ]
            self.navigationItem.title = "대화"
            
            navigationController?.navigationBar.barTintColor = .black
        }else {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.black
            ]
            self.navigationItem.title = "대화"
            
            navigationController?.navigationBar.barTintColor = .white
        }
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return chats.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
    
        // Configure the cell
        cell.chat = chats[indexPath.row]
    
        return cell
    }
    
    // MARK: Collectionview Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let me = self.me else { return }
        let chat = chats[indexPath.row]
        let chatVC = ChatController(chat: chat, me: me)
        chatVC.delegate = self
        navigationController?.pushViewController(chatVC, animated: true)
    }

 

}

// MARK: set size and interspace of cell
extension MessageController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MessageController:ChatControllerDelegate {
    func userLeave(chatController: ChatController) {
        print("1")
        guard let user = chatController.user else { return }
        print("2")
        self.popupDialog(title: "\(user.username)님께서 대화방을 나가셨습니다.", message: "\(user.username)님과는 더이상의 매칭이 불가능합니다.", image: #imageLiteral(resourceName: "loveOfMidterm"))
    }
    
    
}
