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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ticket"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]

        Utilities.styleFloatButton(cancelButton)
        
        setupTicketInfo()
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
//        discountLabel.text
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

        let cancelRequest: [String: Any] = ["ticket": ticket.id]
        db.collection("Cancel_ticket_request").document(ticket.id).setData(cancelRequest) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.cancelButton.isEnabled = false
            }
        }
    }
    
}
