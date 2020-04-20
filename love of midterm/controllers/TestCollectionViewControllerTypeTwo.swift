//
//  TestCollectionViewControllerTypeTwo.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestCollectionViewControllerTypeTwo: UICollectionViewController {
    
    // MARK: Properties
    
    let user:User
    var tests = [Test]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: UIKits
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(self.user.username, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        button.addTarget(self, action: #selector(backButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: Life cycles
    
    init(user:User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(TestCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 다크 테마
            collectionView.backgroundColor = .black
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.barStyle = .black
        }else {
            // 라이트 테마
            collectionView.backgroundColor = .white
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.barStyle = .default
        }
    }
    
    // MARK: Selectors
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: APIs
    func fetchTests(){
        TestService.shared.fetchAllMyTests(user: self.user) { (error, tests) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                guard let tests = tests else { return }
                self.tests = tests
            }
        }
    }
    
    // MARK: Configures
    func configure(){
        configureNavigationBar()
        fetchTests()
        configureUI()
        
    }
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        if self.traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.barTintColor = .black
        }else {
            navigationController?.navigationBar.barTintColor = .white
        }
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            collectionView.backgroundColor = .black
        }else {
            collectionView.backgroundColor = .white
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tests.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TestCell
    
        // Configure the cell
        cell.test = self.tests[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seeTestViewController = SeeTestViewController(test: self.tests[indexPath.row])
        navigationController?.pushViewController(seeTestViewController, animated: true)
    }

}

extension TestCollectionViewControllerTypeTwo:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
