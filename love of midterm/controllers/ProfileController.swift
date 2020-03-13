//
//  ProfileController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import LoadingShimmer
import YPImagePicker
import FSPagerView

private let reuseIdentifier = "cell"

class ProfileController: UIViewController {
    
    // MARK: properties
    var user:User? {
        didSet {
            configureUser()
            fetchBackgroundImages()
        }
    }
    
    var backgroundImages = [UIImage]() {
        didSet {
            pagerView.reloadData()
        }
    }
    
    let pagerView = FSPagerView()
    
    
    lazy var topCustomNavigationBar:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tinderColor
        return view
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 90).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 90).isActive = true
        iv.layer.cornerRadius = 45
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        return iv
    }()
    
    lazy var backgroundImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var plusButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .tinderColor
        button.widthAnchor.constraint(equalToConstant: 38).isActive = true
        button.heightAnchor.constraint(equalToConstant: 38).isActive = true
        button.layer.cornerRadius = 19
        button.imageView?.image = button.imageView?.image?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor.white
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 2.0
        button.layer.shadowColor = UIColor.darkGray.cgColor
        
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 20)
        return label
    }()
    
    lazy var bioLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 20)
        label.text = "bio"
        return label
    }()
    
    lazy var bioTextLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        
        let attributedString = NSMutableAttributedString(string: "")
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        label.attributedText = attributedString
        
        
        
        return label
    }()
    
    
    lazy var editOrChallengeButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 15
        button.backgroundColor = .tinderColor2
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 17)
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 2.0
        button.layer.shadowColor = UIColor.darkGray.cgColor
        return button
    }()

    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: APIs
    
    func fetchBackgroundImages(){
        guard let user = user else { return }
        BackgroundImageService.shared.fetchBackgroundImage(user: user) { (backgroundImages, errorString) in
            LoadingShimmer.startCovering(self.view, with: nil)
            if let errorString = errorString {
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다", message: errorString, image: #imageLiteral(resourceName: "loveOfMidterm"))
                LoadingShimmer.stopCovering(self.view)
            }else {
                guard let backgroundImages = backgroundImages else { return }
                var images = [UIImage]()
                for backgroundImage in backgroundImages {
                    if let url = URL(string: backgroundImage.downloadUrl) {
                        do {
                            let data = try Data(contentsOf: url)
                            let image = UIImage(data: data)
                            guard let finalImage = image else { return }
                            images.append(finalImage)
                        }catch {
                            
                        }
                        
                    }
                }
                images.append(#imageLiteral(resourceName: "loveOfMidterm"))
                self.backgroundImages = images
                LoadingShimmer.stopCovering(self.view)
            }
        }
    }
    
    
    // MARK: selectors
    @objc func plusButtonTapped(){
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 7
        config.screens = [.library]
        config.wordings.libraryTitle = "사진첩"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.hidesBottomBar = true
        let attributes = [NSAttributedString.Key.font : UIFont(name: "BMJUAOTF", size: 18) ]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any] // Title fonts
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal) // Bar Button fonts
        config.colors.tintColor = .tinderColor // Right bar buttons (actions)
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    if let modifiedImage = photo.modifiedImage {
                        BackgroundImageService.shared.postBackgroundImage(image: modifiedImage) { (error, errorString) in
                            if let error = error {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: error.localizedDescription, image: modifiedImage)
                                return
                            }
                            if let errorString = errorString {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: errorString, image: modifiedImage)
                                return
                            }
                            self.backgroundImages.insert(modifiedImage, at: 0)
                        }
                    }else {
                        BackgroundImageService.shared.postBackgroundImage(image: photo.originalImage) { (error, errorString) in
                            if let error = error {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: error.localizedDescription, image: photo.originalImage)
                                return
                            }
                            if let errorString = errorString {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: errorString, image: photo.originalImage)
                                return
                            }
                            self.backgroundImages.insert(photo.originalImage, at: 0)
                        }
                        
                    }
                    
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: configures
    
    func configureUser(){
        guard let user = self.user else { return }
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        
        if Auth.auth().currentUser?.uid != user.id {
            
            self.plusButton.isHidden = true
            self.editOrChallengeButton.setTitle("도전하기", for: .normal)
            
            
        }else {
            self.editOrChallengeButton.setTitle("프로필 변경", for: .normal)
        }
        
        usernameLabel.text = user.username
        
        
        let attributedString = NSMutableAttributedString(string: user.bio)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        bioTextLabel.attributedText = attributedString
        
        
        
        LoadingShimmer.stopCovering(self.view)
    }
    
    func configure(){
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        pagerView.isInfinite = true
        pagerView.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.crossFading)
        backgroundImages.append(#imageLiteral(resourceName: "loveOfMidterm"))
        
        DispatchQueue.main.async {
            LoadingShimmer.startCovering(self.view, with: nil)
        }
        configureUI()
        view.backgroundColor = .white
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func configureUI(){
        view.addSubview(topCustomNavigationBar)
        topCustomNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        topCustomNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topCustomNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topCustomNavigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topCustomNavigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topCustomNavigationBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: topCustomNavigationBar.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.65).isActive = true
        
        view.addSubview(pagerView)
        pagerView.translatesAutoresizingMaskIntoConstraints = false
        pagerView.topAnchor.constraint(equalTo: topCustomNavigationBar.bottomAnchor).isActive = true
        pagerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pagerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pagerView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.65).isActive = true
        
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topCustomNavigationBar.bottomAnchor, constant: -30).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.rightAnchor.constraint(equalTo: pagerView.rightAnchor, constant: -20).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: pagerView.bottomAnchor, constant: -20).isActive = true
        
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: pagerView.bottomAnchor, constant: 10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        view.addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 45).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        view.addSubview(bioTextLabel)
        bioTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bioTextLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 10).isActive = true
        bioTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bioTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(editOrChallengeButton)
        editOrChallengeButton.translatesAutoresizingMaskIntoConstraints = false
        editOrChallengeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editOrChallengeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        
    }
    

}

extension ProfileController:FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.backgroundImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, at: index)
        cell.imageView?.image = self.backgroundImages[index]
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        print("pager view did selected")
        pagerView.deselectItem(at: index, animated: true)
    }
    
}
