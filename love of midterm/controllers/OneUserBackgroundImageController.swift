//
//  OneUserBackgroundImage.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

class OneUserBackgroundImageController: UIViewController {
    
    // MARK: Properties
    
    let imageUrlString:String
    
    // MARK: UIKits
    
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        if let url = URL(string: self.imageUrlString) {
            iv.sd_setImage(with: url, completed: nil)
        }
        return iv
    }()
    
    // MARK: Life cycles
    
    init(imageUrlString:String) {
        self.imageUrlString = imageUrlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: configure
    func configure(){
        view.backgroundColor = .white
        
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = .spaceGray
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
}
