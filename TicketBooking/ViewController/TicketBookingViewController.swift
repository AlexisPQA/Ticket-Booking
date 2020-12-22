//
//  TicketBookingViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit

class TicketBookingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ticket booking"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
    }

}
