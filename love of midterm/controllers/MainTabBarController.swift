//
//  MainTabBarController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserIsLoggedIn()

    }
    
    // configure
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func configure(){
        let profileVC = UINavigationController(rootViewController: ProfileController())
        let searchVC = UINavigationController(rootViewController: SearchController())
        let messageVC = UINavigationController(rootViewController: MessageController())
        
        profileVC.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        searchVC.tabBarItem.image = #imageLiteral(resourceName: "search_unselected")
        messageVC.tabBarItem.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        
        viewControllers = [profileVC, searchVC, messageVC]
    }
    
    func checkUserIsLoggedIn(){
        view.backgroundColor = UIColor.tinderColor
        
        // TODO: 여기서 유저가 로그인했는지 안했는지 체크해줘야함
        // 로그인을 해주었다면 configure 함수 호출
        
        
        let loginVC = UINavigationController(rootViewController: LoginController())
        loginVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    
    
    
}
