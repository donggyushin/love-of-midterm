//
//  SearchController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import LoadingShimmer

private let reuseIdentifier = "Cell"

class SearchController: UICollectionViewController {
    
    // MARK: properties
    var users = [User]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var me:User?
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: Life Cycles
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchUsers()

    }
    // MARK: APIs
    
    func fetchUsers(){
        
        LoadingShimmer.startCovering(self.collectionView, with: nil)
        UserService.shared.fetchUsers { (error, users) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.users = users!
            }
            LoadingShimmer.stopCovering(self.collectionView)
        }
    }
    
    // MARK: Selectors
    @objc func refresh(){
        UserService.shared.fetchUsers { (error, users) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.users = users!
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: configures
    func configure(){
        configureUI()
        configureNavigationBar()
        navigationItem.title = "대화상대 찾기"
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refreshControl
        }else {
            self.collectionView.addSubview(refreshControl)
        }
        
        self.collectionView!.register(UserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BMJUAOTF", size: 18)!,
                                                                        NSAttributedString.Key.foregroundColor:UIColor.tinderColor
        ]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func configureUI(){
        collectionView.backgroundColor = .white
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCell
    
        // Configure the cell
        cell.user = users[indexPath.row]
        if let me = self.me {
            cell.me = me
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profileVCTypeTwo = ProfileControllerTypeTwo()
        profileVCTypeTwo.user = self.users[indexPath.row]
        profileVCTypeTwo.me = self.me
        navigationController?.pushViewController(profileVCTypeTwo, animated: true)
        
    }

  
}

// MARK: Collection view cell size and line spacing

extension SearchController:UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
