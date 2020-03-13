//
//  MainTabBarController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    // MARK: properties
    var user:User? {
        didSet {
            let profileNavigationVC = self.viewControllers?[0] as! UINavigationController
            let profileVC = profileNavigationVC.viewControllers.first as! ProfileController
            profileVC.user = self.user
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserIsLoggedIn()

    }
    
    // MARK: configure
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
        
        
        if(Auth.auth().currentUser == nil){
            view.backgroundColor = UIColor.tinderColor
            let loginVC = UINavigationController(rootViewController: LoginController())
            loginVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(loginVC, animated: true, completion: nil)
            }
        }else {
            configure()
            UserService.shared.fetchUser { (user) in
                self.user = user
            }
        }
        
        
    }
    
    
    
    
}
