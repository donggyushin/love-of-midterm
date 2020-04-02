//
//  BackgroundViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/17.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class BackgroundViewController: UIViewController {
    
    // MARK: properties
    var backgroundImages:[BackgroundImage]
    var currentIndex:Int
    let user:User
    let me:User
    let profileVC:ProfileController
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    
    // MARK: UIKits
    
    let pagerView = FSPagerView()
    let pageControl = FSPageControl()
    
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.setTitle("돌아가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.setTitle("사진 내리기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: life cycles
    
    init(backgroundImages:[BackgroundImage], index:Int, me:User, user:User, profileVC:ProfileController) {
        self.backgroundImages = backgroundImages
        self.currentIndex = index
        self.me = me
        self.user = user
        self.profileVC = profileVC
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        configureUI()
    }
    
    // MARK: helpers
    
    func configDeleteButton(){
        
        if user.id != me.id {
            self.deleteButton.isHidden = true
            return
        }
        
        if pagerView.currentIndex == backgroundImages.count - 1 {
            self.deleteButton.isHidden = true
        }else {
            self.deleteButton.isHidden = false
        }
        
    }
    
    // MARK: selectors
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
        if viewTranslation.y < 200 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
        default:
            break
        }
    }
    
    @objc func deleteButtonTapped(){
        if pagerView.currentIndex == backgroundImages.count - 1 {
            return
        }
        guard user.id == me.id else { return }
        let backgroundImageToDelete = backgroundImages[pagerView.currentIndex]
        BackgroundImageService.shared.deleteBackgroundImage(user: user, backgroundImage: backgroundImageToDelete) { (error) in
            if let error = error {
                self.popupDialog(title: "경고", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                
                self.backgroundImages.remove(at: self.pagerView.currentIndex)
                self.pagerView.reloadData()
                
                self.profileVC.deleteBackgroundImage(index: self.pagerView.currentIndex)
            }
            
        }
    }
    
    @objc func cancleButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: configures
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configureUI(){
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        configDeleteButton()
        
        view.backgroundColor = .spaceGray
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        view.addSubview(pagerView)
        pagerView.translatesAutoresizingMaskIntoConstraints = false
        pagerView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50).isActive = true
        pagerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        pagerView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }

}


// MARK: FSPagerView Datasource and Delegate
extension BackgroundViewController:FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return backgroundImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.contentMode = .scaleAspectFill
        if let url = URL(string: backgroundImages[index].downloadUrl) {
            cell.imageView?.sd_setImage(with: url, completed: nil)
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "loveOfMidterm")
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        configDeleteButton()
    }
    
}
