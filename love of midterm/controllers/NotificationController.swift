//
//  NotificationController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/23.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseIdentifierForDenyRequest = "Cell2"

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
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두운 테마일때
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.white
            ]
            
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = .black
            self.collectionView.backgroundColor = .black
        }else {
            // 밝은 테마일때
            self.collectionView.backgroundColor = .white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.black
            ]
            
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    // MARK: configures
    func configure(){
        
        
        
        
        self.collectionView!.register(RequestCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(DenyRequestCell.self, forCellWithReuseIdentifier: reuseIdentifierForDenyRequest)

    }

    func configureNavigationBar(){
        self.navigationItem.title = "알림"
        if self.traitCollection.userInterfaceStyle == .dark {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.white
            ]
            self.collectionView.backgroundColor = .black
            
            navigationController?.navigationBar.barTintColor = .black
        }else {
            self.collectionView.backgroundColor = .white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy),
                                                                            NSAttributedString.Key.foregroundColor:UIColor.black
            ]
            
            
            navigationController?.navigationBar.barTintColor = .white
            
        }
        
        
        
        navigationController?.navigationBar.isTranslucent = false
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
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
        
        
        let request = requests[indexPath.row]
        if request.type == "PASS" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RequestCell
            
                // Configure the cell
                cell.request = request
                cell.delegate = self
                return cell
        } else if request.type == "DENY" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierForDenyRequest, for: indexPath) as! DenyRequestCell
            cell.request = request
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RequestCell
            
                return cell
        }
        
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
