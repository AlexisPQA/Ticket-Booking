//
//  HomeViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/21/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var rectangle: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleView(rectangle)
        Utilities.styleTextField1(fromTextField)
        Utilities.styleTextField1(toTextField)
        
    }
    
}
