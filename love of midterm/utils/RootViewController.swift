//
//  rootViewController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/14.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import UIKit

struct RootViewController {
    static let rootViewController = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
        .filter({$0.isKeyWindow}).first?.rootViewController as! MainTabBarController
}
