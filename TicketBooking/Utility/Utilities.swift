//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static let mainColor = UIColor.init(red: 254/255, green: 135/255, blue: 129/255, alpha: 1)
    static let subColor = UIColor.init(hue: 219/255, saturation: 229/255, brightness: 243/255, alpha: 1)
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)

        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 254/255, green: 135/255, blue: 129/255, alpha: 1)
        button.layer.cornerRadius = button.frame.size.height/2.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func stylePickerButton(_ button:UIButton) {
        button.backgroundColor = subColor
        button.layer.cornerRadius = button.frame.size.height/2
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.16)
        button.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        button.layer.shadowRadius = 6
    }
    
    static func styleImageFrame(_ imageView : UIImageView) {
        imageView.layer.cornerRadius = 15
    }
    
}
