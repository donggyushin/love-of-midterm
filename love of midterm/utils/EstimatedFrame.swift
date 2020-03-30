//
//  EstimatedFrame.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/30.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import UIKit

struct EstimatedFrame {
    static let shared = EstimatedFrame()
    
    func getEstimatedFrame(messageText:String, width:Int, font:UIFont) -> CGRect {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        return estimatedFrame
    }
}
