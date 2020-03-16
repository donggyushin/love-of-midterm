//
//  extensions.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/13.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

extension UIColor {
    static let tinderColor = UIColor(red:1.00, green:0.24, blue:0.45, alpha:1.0)
    static let tinderColor2 = UIColor(red:1.00, green:0.35, blue:0.39, alpha:1.0)
    static let tinderColor3 = UIColor(red:1.00, green:0.40, blue:0.36, alpha:1.0)
    
    static let facebookBlue = UIColor(red:0.26, green:0.40, blue:0.70, alpha:1.0)
    static let spaceGray = UIColor(red:0.18, green:0.20, blue:0.21, alpha:1.0)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func moveViewWithKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}


extension UIViewController {
    
    func makeNavigationBarTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    func popupDialog(title:String, message:String, image:UIImage){
        
        
        
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = .black
        
        
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.blurRadius      = 30
        ov.liveBlurEnabled = true
        ov.opacity         = 0.7
        ov.color           = .black
        
        
        let pv = PopupDialogDefaultView.appearance()
        
        
        pv.titleFont = UIFont(name: "BMJUAOTF", size: 15)!
        pv.titleColor = .white
        
        pv.messageFont = UIFont(name: "BMJUAOTF", size: 14)!
        pv.messageColor = .white
        
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "BMJUAOTF", size: 14)!
        db.titleColor     = .white
        db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
        db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
        
        
        let popup = PopupDialog(title: title, message: message, image: image)
        

        let buttonThree = DefaultButton(title: "확인", height: 60) {
            print("Ah, maybe next time :)")
        }
        popup.addButtons([ buttonThree])

        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}


extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
