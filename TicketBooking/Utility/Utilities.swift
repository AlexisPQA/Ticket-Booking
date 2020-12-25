//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
let viewColor = UIColor.init(red: 219/255, green: 229/255, blue: 243/255, alpha: 1)
let btnColor = UIColor.init(red: 254/255, green: 135/255, blue: 129/255, alpha: 1)
class Utilities {
    
    
    static func styleView(_ view:UIView){
        view.layer.cornerRadius = 10
        view.backgroundColor = viewColor
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
    
    static func styleFilledButton(_ button:UIButton,_ type:Int) {
        if type == 1{
        // Filled rounded corner style
        button.backgroundColor = btnColor
        button.layer.cornerRadius = button.frame.size.height/2.0
        button.tintColor = UIColor.white
        }
        else{
            button.backgroundColor = viewColor
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
    
}
