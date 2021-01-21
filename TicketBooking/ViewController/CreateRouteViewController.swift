//
//  CreateRouteViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/21/21.
//

import UIKit

class CreateRouteViewController: UIViewController {
    
    @IBOutlet var listOfSeat: [UIButton]!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var departureTimeTextField: UITextField!
    @IBOutlet weak var licenseplateTextField: UITextField!
    @IBOutlet weak var ticketpriceTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create Route"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped)), animated: true)
        self.navigationController?.navigationBar.tintColor = .black
    }
    

    @objc func doneTapped(){
        print("ádjkasjdasjkdsakjd")
    }
    @IBAction func seatTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = .init(red: 254/255, green: 135/255, blue: 129/255, alpha: 1)
//            updatePrice(0)
        } else {
            sender.backgroundColor = .init(red: 219/255, green: 229/255, blue: 243/255, alpha: 1)
//            updatePrice(1)
        }

    }

}
