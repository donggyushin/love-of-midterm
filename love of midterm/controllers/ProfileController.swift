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
import SideMenu

private let reuseIdentifier = "cell"


class ProfileController: UIViewController {
    
    // MARK: properties
    
    let sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController())
    
    
    var user:User? {
        didSet {
            configureUser()
            fetchBackgroundImages()
            fetchAddress()
        }
    }
    
    var me:User?
    
    var address:Address? {
        didSet {
            configureAddress()
        }
    }
    
    
    var backgroundImages = [BackgroundImage]() {
        didSet {
            pagerView.reloadData()
        }
    }
    
    let pagerView = FSPagerView()
    
    // MARK: UIKits
    
    
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
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        iv.addGestureRecognizer(tap)
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
        label.font = UIFont(name: "BMJUAOTF", size: 15)
        return label
    }()
    
    lazy var genderMarker:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
    
        return iv
    }()
    
    lazy var birthdayLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 13)
        label.textColor = .lightGray
        label.text = "94년생"
        return label
    }()
    
    lazy var addressLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 13)
        label.text = "?? km"
        label.textColor = .lightGray
        return label
    }()
    
    
    lazy var bioTextLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "BMJUAOTF", size: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.textColor = .darkText
        
        let attributedString = NSMutableAttributedString(string: "")
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 1 // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        label.attributedText = attributedString
        
        
        
        return label
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
    
    // MARK: Helpers
    
    func deleteBackgroundImage(index:Int){
        self.backgroundImages.remove(at: index)
        self.pagerView.reloadData()
    }
    
    // MARK: APIs
    
    func fetchAddress(){
        guard let user = self.user else { return }
        AddressService.shared.fetchAddress(user: user) { (error, address) in
            if let error = error {
                self.popupDialog(title: "경고", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.address = address
            }
        }
    }
    
    func fetchBackgroundImages(){
        guard let user = user else { return }
        BackgroundImageService.shared.fetchBackgroundImage(user: user) { (backgroundImages, errorString) in
            if let errorString = errorString {
                self.popupDialog(title: "이용에 불편을 끼쳐드려 죄송합니다", message: errorString, image: #imageLiteral(resourceName: "loveOfMidterm"))
                LoadingShimmer.stopCovering(self.view)
            }else {
                guard let backgroundImages = backgroundImages else { return }
                var backgroundImage = BackgroundImage(downloadUrl: "", id: "", referenceId: "", userId: "")
                backgroundImage.image = #imageLiteral(resourceName: "loveOfMidterm")
                var backgroundImagesTemp = backgroundImages
                backgroundImagesTemp.append(backgroundImage)
                self.backgroundImages = backgroundImagesTemp
            }
        }
    }
    
    
    // MARK: selectors
    
    @objc func profileImageTapped(){
        present(sideMenu, animated: true, completion: nil)
    }
    
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
                        BackgroundImageService.shared.postBackgroundImage(image: modifiedImage) { (error, errorString, backgroundImage) in
                            if let error = error {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: error.localizedDescription, image: modifiedImage)
                                return
                            }
                            if let errorString = errorString {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: errorString, image: modifiedImage)
                                return
                            }
                            self.backgroundImages.insert(backgroundImage!, at: 0)
                        }
                    }else {
                        BackgroundImageService.shared.postBackgroundImage(image: photo.originalImage) { (error, errorString, backgroundImage) in
                            if let error = error {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: error.localizedDescription, image: photo.originalImage)
                                return
                            }
                            if let errorString = errorString {
                                self.popupDialog(title: "업로드에 실패하였습니다", message: errorString, image: photo.originalImage)
                                return
                            }
                            self.backgroundImages.insert(backgroundImage!, at: 0)
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
    
    func configureAddress(){
        guard let address = self.address else { return }
        
        addressLabel.text = address.title
        
        
    }
    
    func configureUser(){
        guard let user = self.user else { return }
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        if user.gender == "female" {
            
            self.genderMarker.image = #imageLiteral(resourceName: "female")
            self.genderMarker.image = self.genderMarker.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.genderMarker.tintColor = UIColor.tinderColor
        
            
        }else {
        
            self.genderMarker.image = #imageLiteral(resourceName: "male")
            self.genderMarker.image = self.genderMarker.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            self.genderMarker.tintColor = UIColor.facebookBlue
            
        }
        
        
        let birthdayYear = String(user.birthday.year())
        birthdayLabel.text = String(birthdayYear.suffix(2))+"년생"
        
        
        if Auth.auth().currentUser?.uid == user.id {
//            self.editOrChallengeButton.isHidden = true
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
        var backgroundImage = BackgroundImage(downloadUrl: "", id: "", referenceId: "", userId: "")
        backgroundImage.image = #imageLiteral(resourceName: "loveOfMidterm")
        backgroundImages.append(backgroundImage)
        
        sideMenu.statusBarEndAlpha = 0
        sideMenu.menuWidth = view.frame.width * 0.73
        
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
        
        navigationController?.navigationBar.barTintColor = .tinderColor
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
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
        pagerView.heightAnchor.constraint(equalToConstant: view.frame.width * 1).isActive = true
        
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
        
        view.addSubview(genderMarker)
        genderMarker.translatesAutoresizingMaskIntoConstraints = false
        genderMarker.topAnchor.constraint(equalTo: pagerView.bottomAnchor, constant: 10).isActive = true
        genderMarker.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
        
        view.addSubview(birthdayLabel)
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        birthdayLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 10).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

        
        view.addSubview(bioTextLabel)
        bioTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bioTextLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 40).isActive = true
        bioTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bioTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    

}

// MARK: FSPagetView Delegate and Datasource
extension ProfileController:FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.backgroundImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, at: index)
        let backgroundImage = self.backgroundImages[index]
        if let image = backgroundImage.image {
            cell.imageView?.image = image
        }else {
            if let url = URL(string: backgroundImage.downloadUrl) {
                cell.imageView?.sd_setImage(with: url, completed: nil)
            }
        }
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let user = user, let me = me else { return }
        guard backgroundImages.count != 0 else { return }
        let backgroundViewVC = BackgroundViewController(backgroundImages: backgroundImages, index: index, me: me, user: user, profileVC: self)
        backgroundViewVC.modalPresentationStyle = .overFullScreen
        present(backgroundViewVC, animated: true, completion: nil)
        pagerView.deselectItem(at: index, animated: true)
    }
    
}
