//
//  TicketInfoViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/23/20.
//

import UIKit

class TicketInfoViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ticket"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]

        Utilities.styleFloatButton(cancelButton)
    }

}
