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

extension UICollectionViewController {
    
    
    func scrollToBottom(){
        let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .top, animated: true)
    }
}

extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}

extension UIColor {
    static let tinderColor = UIColor(hex: "#FE3C72")
    static let tinderColor2 = UIColor(red:1.00, green:0.35, blue:0.39, alpha:1.0)
    static let tinderColor3 = UIColor(red:1.00, green:0.40, blue:0.36, alpha:1.0)
    
    static let facebookBlue = UIColor(red:0.26, green:0.40, blue:0.70, alpha:1.0)
    static let spaceGray = UIColor(red:0.18, green:0.20, blue:0.21, alpha:1.0)
    static let veryLightGray = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
    
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension UIViewController {
    
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    
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
    
    func dialogRedirectsToPostTestController(goToPostTestController:@escaping() -> Void){
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
        
        
        let popup = PopupDialog(title: "반갑습니다 '중간의 연애'입니다", message: "'중간의 연애'는 상대방에게 말을 걸기 전에 상대방이 출제한 시험 문제를 모두 풀어야 상대방에게 말을 걸 수 있습니다. 본인에 대한 문제를 출제해주세요!", image: #imageLiteral(resourceName: "loveOfMidterm"), tapGestureDismissal: false, panGestureDismissal: false)
        
        let buttonThree = DefaultButton(title: "확인", height: 60) {
            goToPostTestController()
        }
        
        popup.addButtons([ buttonThree])

        // Present dialog
        self.present(popup, animated: true)
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


class TextField: UITextField {

let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
}

override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
}

override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
}
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


extension NSAttributedString {

    func height(containerWidth: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }

    func width(containerHeight: CGFloat) -> CGFloat {

        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.width)
    }
}
