//
//  TabbarViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/24/20.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.clipsToBounds = true // remove top line of tabbar
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: 0, width: self.tabBar.bounds.width - 60, height: 67), cornerRadius:20).cgPath
        layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16).cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor(red: 219/255, green: 229/255, blue: 243/255, alpha: 1).cgColor
        self.tabBar.layer.insertSublayer(layer, at: 0)
        
    }
    

}
