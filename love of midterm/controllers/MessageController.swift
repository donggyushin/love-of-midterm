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
    
    // MARK: configures
    
    func configure(){
        collectionView.backgroundColor = .white
        configureNavigationBar()
        self.collectionView!.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BMJUAOTF", size: 18)!,
                                                                        NSAttributedString.Key.foregroundColor:UIColor.tinderColor
        ]
        self.navigationItem.title = "대화"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
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
