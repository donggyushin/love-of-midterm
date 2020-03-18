//
//  PostBioController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/18.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class PostBioController: UIViewController {

    
    
    // MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: configures
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
    }
    
}
