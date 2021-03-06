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
    static let mainColor = UIColor.init(red: 254/255, green: 135/255, blue: 129/255, alpha: 1) // view
    static let subColor = UIColor.init(red: 219/255, green: 229/255, blue: 243/255, alpha: 1) // button
    static func styleView(_ view:UIView, _ color:UIColor){
        view.layer.cornerRadius = 10
        view.backgroundColor = color
        view.layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16).cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    static func styleTextField1(_ textfield:UITextField){
        textfield.layer.cornerRadius = textfield.frame.height/2.0
        textfield.clipsToBounds = true
    }
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
    
    static func styleFilledButtonFilter(_ button:UIButton) {
        // Filled rounded corner style
        button.backgroundColor = .none
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor.cgColor
        button.layer.cornerRadius = button.frame.size.height/2.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButton(_ button:UIButton,_ type:Int) {
        if type == 1{
        // Filled rounded corner style
        button.backgroundColor = mainColor
        button.layer.cornerRadius = button.frame.size.height/2.0
        button.tintColor = UIColor.white
        }
        else{ // for button like datepicker ,coupon
            button.backgroundColor = subColor
            button.layer.cornerRadius = button.frame.size.height/2.0
            button.tintColor = UIColor.white
            button.layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16).cgColor
            button.layer.shadowRadius = 5.0
            button.layer.shadowOpacity = 1.0
            button.layer.masksToBounds = false
            button.layer.shadowOffset = CGSize(width: 0, height: 5)
            button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
        }
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
    
    static func styleFloatButton(_ button:UIButton) {
        button.layer.cornerRadius = button.frame.size.height/2
        button.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.shadowOffset = .init(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.16
    }
    
    static func styleImageFrame(_ imageView : UIImageView) {
        imageView.layer.cornerRadius = 15
    }
}
