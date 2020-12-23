//
//  StationInfoViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit

class StationInfoViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var utilitiesIncluedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bus station"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        
        Utilities.styleImageFrame(image)
    }

    @IBAction func showGarageView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "garageInfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showBookingView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ticketBookingViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showTicketView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ticketInfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
