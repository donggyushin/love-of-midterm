//
//  TestCollectionViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/10.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    let user:User
    
    var tests = [Test]()
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("뒤로", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        button.addTarget(self, action: #selector(backbuttonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
    // MARK: Life Cycles
    
    init(user:User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        extendedLayoutIncludesOpaqueBars = true
        
        self.collectionView!.register(TestCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configure()
        fetchTests()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: 테마 바뀔 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            collectionView.backgroundColor = .black
        }else {
            collectionView.backgroundColor = .white
        }
    }
    
    // MARK: APIs
    func fetchTests(){
        TestService.shared.fetchAllMyTests(user: user) { (error, tests) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.tests = tests!
                self.collectionView.reloadData()
            }
            
        }
    }
    
    // MARK: Selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
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
        cell.test = tests[indexPath.row]
    
        return cell
    }


    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let test = tests[indexPath.row]
        let updateTestViewController = UpdateTestViewController(test: test)
        updateTestViewController.delegate = self
        navigationController?.pushViewController(updateTestViewController, animated: true)
    }
    
    // MARK: Configures
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            collectionView.backgroundColor = .black
        }else {
            collectionView.backgroundColor = .white
        }
        
    }


}


// MARK: Configure collectionViewCell size

extension TestCollectionViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let font = UIFont(name: "BMJUAOTF", size: 15) else {
            return CGSize(width: view.frame.width, height: 80)
        }
        let test = tests[indexPath.row]
        let estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: test.title, width: Int(view.frame.width) - 52, font: font)
        return CGSize(width: view.frame.width, height: 65 + estimatedFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension TestCollectionViewController:UpdateTestViewControllerDelegate {
    func updateTest(cell: UpdateTestViewController) {
        fetchTests()
    }
}
