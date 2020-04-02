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
            profileVC.me = self.user
            
            let searchControllerNavigation = self.viewControllers?[1] as! UINavigationController
            let searchVC = searchControllerNavigation.viewControllers.first as! SearchController
            searchVC.me = self.user
            
            let notificationNavigation = self.viewControllers?[2] as! UINavigationController
            let notificationVC = notificationNavigation.viewControllers.first as! NotificationController
            notificationVC.me = self.user
            
            let messageNavigation = self.viewControllers?[3] as! UINavigationController
            let messageVC = messageNavigation.viewControllers.first as! MessageController
            messageVC.me = self.user
            
            checkUserHasTest()
            listenRequestsCount()
            listenRequests()
            fetchChats()
            listenUnreadMessagesCount()
        }
    }
    
    var requestCount = 0
    var requests = [Request]()
    var unreadMessagesCount = 0
    var chats:[Chat]? {
        didSet {
            let messageNavigationController = self.viewControllers?[3] as? UINavigationController
            let messageController = messageNavigationController?.viewControllers.first as! MessageController
            messageController.chats = self.chats!
            
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserIsLoggedIn()
        
    }
    
    // MARK: APIs
    
    func fetchUser(){
        UserService.shared.fetchUser { (user) in
            self.user = user
        }
    }
    
    func fetchChats(){
        ChatService.shared.listenChats { (error, chats) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.chats = chats
            }
        }
    }
    
    func listenUnreadMessagesCount(){
        MessageService.shared.listenUnreadMessagesCount { (error, int) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.unreadMessagesCount = int!
                let messageNavigationController = self.viewControllers?[3] as? UINavigationController
                if self.unreadMessagesCount == 0 {
                    messageNavigationController?.tabBarItem.badgeValue = nil
                }else {
                    messageNavigationController?.tabBarItem.badgeValue = "\(self.unreadMessagesCount)"
                }
            }
        }
    }
    
    func listenRequests(){
        RequestService.shared.listenRequests { (error, request) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.requests.append(request!)
                let notificationNavigationController = self.viewControllers?[2] as? UINavigationController
                let notificationController = notificationNavigationController?.viewControllers.first as! NotificationController
                notificationController.requests = self.requests
            }
        }
    }
    
    func listenRequestsCount(){
        RequestService.shared.fetchRequestForCounting { (error, requestCount) in
            if let error = error {
                self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.requestCount = requestCount!
                let notificationNavigationController = self.viewControllers?[2] as? UINavigationController
                
                if self.requestCount != 0 {
                    notificationNavigationController?.tabBarItem.badgeValue = "\(self.requestCount)"
                } else {
                    notificationNavigationController?.tabBarItem.badgeValue = nil
                }
                
            }
        }
    }
    
    // MARK: helpers
    
    
    func checkUserHasTest(){
        guard let user = user else { return }
        if user.testIds.count != 10 {
            self.dialogRedirectsToPostTestController(goToPostTestController: goToPostTestController)
        }
    }
    
    
    
    func goToPostTestController(){
        let postTestVC = PostTestController()
        postTestVC.modalPresentationStyle = .fullScreen
        postTestVC.delegate = self
        present(postTestVC, animated: true, completion: nil)
    }
    
    func logoutFunction(){
            view.backgroundColor = UIColor.tinderColor
            let loginVC = UINavigationController(rootViewController: LoginController())
            loginVC.modalPresentationStyle = .fullScreen
        
            self.requestCount = 0
            self.requests = [Request]()
            self.unreadMessagesCount = 0
        

            
            DispatchQueue.main.async {
                self.present(loginVC, animated: true, completion: nil)
            }
        }
        
        func checkUserIsLoggedIn(){
            
    //        try! Auth.auth().signOut()
            
            if(Auth.auth().currentUser == nil){
                logoutFunction()
            }else {
                configure()
            }
            
        }
    
    // MARK: configure
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    func configure(){
        let profileVC = UINavigationController(rootViewController: ProfileController())
        let searchVC = UINavigationController(rootViewController: SearchController())
        let messageVC = UINavigationController(rootViewController: MessageController())
        let notificationVC = UINavigationController(rootViewController: NotificationController())
        
        
        profileVC.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        searchVC.tabBarItem.image = #imageLiteral(resourceName: "search_unselected")
        messageVC.tabBarItem.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        notificationVC.tabBarItem.image = #imageLiteral(resourceName: "like")
        
        viewControllers = [profileVC, searchVC,notificationVC, messageVC]
        
        fetchUser()
        
    }
    
}


extension MainTabBarController:PostTestControllerDelegate {
    func testChangeSuccessPopup() {
        self.popupDialog(title: "완료", message: "시험변경이 모두 성공적으로 완료 되었습니다.", image: #imageLiteral(resourceName: "loveOfMidterm"))
    }   
}
