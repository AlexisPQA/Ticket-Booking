//
//  TicketBookingViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit

class TicketBookingViewController: UIViewController {

    @IBOutlet weak var bookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ticket booking"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        self.navigationController?.navigationBar.backgroundColor = Utilities.mainColor
        
        UINavigationBar.appearance().barTintColor = Utilities.mainColor
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().isTranslucent = false
        
        Utilities.styleFloatButton(bookButton)
    }

}
