//
//  WebViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/04/21.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    // MARK: Properties
    let url:String
    
    // MARK: UIKits
    lazy var webView:WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        return webView
    }()
    
    // MARK: Life cycles
    
    init(url:String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        configure()
        
        
        if let myURL = URL(string: self.url) {
            let myRequest = URLRequest(url: myURL)
            self.webView.load(myRequest)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
        
        if self.traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.barTintColor = .black
        }else {
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    
    // MARK: Configures
    func configure(){
        extendedLayoutIncludesOpaqueBars = true
        configureUI()
        configureNavigation()
    }
    
    func configureNavigation(){
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }


}


extension WebViewController:WKUIDelegate {
    
}
