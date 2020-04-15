//
//  SearchAdressController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/15.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol SearchAddressControllerDelegate:class {
    func addressDidSelected(address:Address)
}

class SearchAddressController: UICollectionViewController {
    
    // MARK: properties
    
    
    var delegate:SearchAddressControllerDelegate?
    
    var addresses = [Address]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    let searchController = UISearchController()
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("주소검색", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(.white, for: .normal)
        }else {
            button.setTitleColor(.black, for: .normal)
        }
        
        return button
    }()

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
        
        if self.traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.barTintColor = .black
        }else {
            navigationController?.navigationBar.barTintColor = .white
        }
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: 테마 바꼈을 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 어두운 테마일때
            self.navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = .black
            backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            collectionView.backgroundColor = .black
        }else {
            // 밝은 테마일때
            self.navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.barTintColor = .white
            backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            collectionView.backgroundColor = .white
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    // MARK: configure()
    func configure(){
        
        if self.traitCollection.userInterfaceStyle == .dark {
            collectionView.backgroundColor = .black
        }else {
            collectionView.backgroundColor = .white
        }
        
        makeNavigationItem()
        collectionView.register(AddressCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func makeNavigationItem(){
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }

    
    
    // MARK: selectors
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
        return addresses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.addressDidSelected(address: addresses[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddressCell
    
        // Configure the cell
        cell.address = addresses[indexPath.row]
    
        return cell
    }
}

extension SearchAddressController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SearchAddressController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let queryString = searchController.searchBar.text else { return }
        
        let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(queryString)"
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        
        guard let url = URL(string: encodedString) else { return }
        
        
        var request = URLRequest(url: url)
        request.setValue(Secrets.client_id, forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue(Secrets.secret_key, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                do {
                    
                    let addressResponse = try JSONDecoder().decode(AddressResponse.self, from: data!)
                    
                    self.addresses = addressResponse.items
                        
                    
                }catch {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    
}
