//
//  TicketInfoViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/23/20.
//

import UIKit
import Firebase

class TicketInfoViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    
    //Departure information
    @IBOutlet weak var departureLocateLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    
    //Seats information
    @IBOutlet weak var garageLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var garagePhoneLabel: UILabel!
    @IBOutlet weak var lisencePlateLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    
    //Passenger information
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet weak var idCardLabel: UILabel!
    @IBOutlet weak var passengerPhoneLabel: UILabel!
    
    //Payment information
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var couponCodeLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var ticket = Ticket()
    var garage = Garage()
    var route = Route()
    var coupon = Coupon()
    var db : Firestore!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ticket"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        self.navigationController?.navigationBar.backgroundColor = Utilities.mainColor
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeTapped)), animated: true)
        self.navigationController?.navigationBar.tintColor = .black
        
        Utilities.styleFloatButton(cancelButton)
        
        setupTicketInfo()
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
    }
    
    @objc func homeTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupTicketInfo() {
        departureLocateLabel.text = garage.address
        destinationLabel.text = route.destination
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        departureTimeLabel.text = dateFormatter.string(from: route.departureTime)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        departureDateLabel.text = dateFormatter.string(from: route.departureTime)
        
        garageLabel.text = garage.name
        stationLabel.text = garage.busStation
        lisencePlateLabel.text = route.licensePlate
        var strSeats = ""
        for seat in ticket.seats  {
            if seat < 23 {
                strSeats += " A\(seat + 1),"
            } else {
                strSeats += " B\(seat -  22),"
            }
        }
        strSeats.remove(at: strSeats.index(before: strSeats.endIndex))
        seatsLabel.text = strSeats
//        seatsLabel.text = "\(seatsLabel.text!.remove(at: seatsLabel.text!.index(before: seatsLabel.text!.endIndex)))"
        departureLabel.text = departureTimeLabel.text! + " " + departureDateLabel.text!
        
        passengerNameLabel.text = ticket.passengerName
        idCardLabel.text = ticket.idCard
        passengerPhoneLabel.text = ticket.phone
    
        priceLabel.text = "\(ticket.price)đ"
        discountLabel.text = "-\(ticket.price - ticket.totalPrice)đ"
        couponCodeLabel.text = ticket.coupon
        if ticket.paymentMethod == 0 {
            paymentMethodLabel.text = "Cast"
        } else {
            paymentMethodLabel.text = "Internet banking"
        }
        totalPriceLabel.text = "\(ticket.totalPrice)đ"
    }
    
    @IBAction func cancelTicketTouched(_ sender: Any) {
        var db: Firestore!
        db = Firestore.firestore()
        
        do {
            // Endcode
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(ticket)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
            db.collection("CancelTicketRequest").document(ticket.id!).setData(json)
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        } catch let error {
            let alert = UIAlertController(title: "Unsuccessfully", message: "Cannot send cancel ticket request because:\n\(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        }
    }
    
}
