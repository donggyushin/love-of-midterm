//
//  NotificationConfigureController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/24.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class NotificationConfigureController: UIViewController {
    
    // MARK: Properties
    
    
    
    // MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: 테마 바꼈을 때
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.userInterfaceStyle == .light {
            // 다크 테마
        }else {
            // 화이트 테마
        }
    }
    
    // MARK: Configures
    func configureUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }else {
            view.backgroundColor = .white
        }
    }
    

}
