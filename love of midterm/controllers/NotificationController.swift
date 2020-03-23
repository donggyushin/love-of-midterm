//
//  NotificationController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NotificationController: UICollectionViewController {
    
    // MARK: Properties
    var requests = [Request]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var me:User?
    
    
    // MARK: Life cycles
    
    init() {
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
        self.collectionView.backgroundColor = .white
        self.collectionView!.register(RequestCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureNavigationBar()
    }

    func configureNavigationBar(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BMJUAOTF", size: 18)!,
                                                                        NSAttributedString.Key.foregroundColor:UIColor.tinderColor
        ]
        self.navigationItem.title = "알림"
        
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
        return self.requests.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RequestCell
    
        // Configure the cell
        cell.request = requests[indexPath.row]
        cell.delegate = self
        return cell
    }
    
}

// MARK: Set collectionviewcell width and height
extension NotificationController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



extension NotificationController:RequestCellDelegate {
    func goToChoiceController(cell: RequestCell) {
        guard let user = cell.user else { return }
        guard let me = self.me else { return }
        guard let request = cell.request else { return }
        let choiceVC = ChoiceController(user: user, me: me, request: request)
        navigationController?.pushViewController(choiceVC, animated: true)
        
    }
}
