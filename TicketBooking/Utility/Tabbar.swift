//
//  Tabbar.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/25/20.
//

import UIKit

class Tabbar: UITabBar {

    @IBInspectable var height: CGFloat = 0.0

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            if height > 0.0 {
                sizeThatFits.height = height
            }
            return sizeThatFits
        }

}
