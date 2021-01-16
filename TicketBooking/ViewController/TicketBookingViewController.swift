//
//  TicketBookingViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit
import Firebase

class TicketBookingViewController: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var passengerNameTextField: UITextField!
    @IBOutlet weak var idCardTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pickupAddressTextField: UITextField!
    @IBOutlet weak var departureLocationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var castButton: UIButton!
    @IBOutlet weak var iBankingButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet var listOfSeat: [UIButton]!
    
    var garage = Garage()
    var route = Route()
    var listOfCoupon: [Coupon] = []
    var currentCoupon: Coupon? = nil
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ticket booking"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        self.navigationController?.navigationBar.backgroundColor = Utilities.mainColor
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeTapped)), animated: true)
        self.navigationController?.navigationBar.tintColor = .black
        
        UINavigationBar.appearance().barTintColor = Utilities.mainColor
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().isTranslucent = false
        
        Utilities.styleFloatButton(bookButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
        
        loadInfoOfRoute()
        loadListOfCoupon()
    }
    
    @objc func homeTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dissmissKeyboard() {
        self.view.endEditing(true)
    }

    func loadInfoOfRoute() {
        //Load the info of the Route
        departureLocationLabel.text = garage.address
        destinationLabel.text = route.destination
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm"
        departureTimeLabel.text = dateFormatter.string(from: route.departureTime)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        departureDateLabel.text = dateFormatter.string(from: route.departureTime)
        priceLabel.text = "0đ"
        discountLabel.text = "0đ"
        totalPriceLabel.text = "0đ"
        
        //Load the Map of seats
        for i in 0...45 {
            listOfSeat[i].tintColor = .clear
            if route.seats[i] == false {
                listOfSeat[i].isEnabled = false
                listOfSeat[i].backgroundColor = .black
                listOfSeat[i].setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @IBAction func seatTouched(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = .init(red: 254/255, green: 135/255, blue: 129/255, alpha: 1)
            updatePrice(0)
        } else {
            sender.backgroundColor = .init(red: 219/255, green: 229/255, blue: 243/255, alpha: 1)
            updatePrice(1)
        }
    }
    
    //state = 0 : add a ticket; state = 1 : remove a ticket; 2: change coupon
    func updatePrice(_ state: Int) {
        // Update priceLabel
        var strPrice = priceLabel.text!
        strPrice.remove(at: strPrice.index(before: strPrice.endIndex)) // remove 'đ' character
        if state == 0 {
            strPrice = "\((Int(strPrice) ?? 0) + route.aSeatPrice)"
        } else if state == 1 {
            strPrice = "\((Int(strPrice) ?? 0) - route.aSeatPrice)"
        }
        priceLabel.text = strPrice + "đ"
            
        // Update totalPriceLabel
        var strDiscount = discountLabel.text!
//        if let coupon = currentCoupon {
//            strDiscount = "\((coupon.discount/100) * Double(strPrice))"
//        }
        
        strDiscount.remove(at: strDiscount.index(before: strDiscount.endIndex)) // remove 'đ' charccter
        print("Discount: \(strDiscount)")
        totalPriceLabel.text = "\((Int(strPrice) ?? 0) + (Int(strDiscount) ?? 0))đ"
    }
    
    @IBAction func paymentMethodTouched(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setImage(UIImage(named: "Radio_Checked"), for: .selected)
        sender.setImage(UIImage(named: "Radio_Checked"), for: .normal)
        //tag = 0 : Cast / tag = 1: iBanking
        if sender.tag == 0 {
            iBankingButton.isEnabled = true
            iBankingButton.setImage(UIImage(named: "Radio_Unchecked"), for: .normal)
        } else {
            castButton.isEnabled = true
            castButton.setImage(UIImage(named: "Radio_Unchecked"), for: .normal)
        }
    }
    
    func loadListOfCoupon() {
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
        
        db.collection("Coupon").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let coupon = Coupon(document: document)
                    self.listOfCoupon.append(coupon)
                }
                self.picker.reloadAllComponents()
            }
        }

        
    }
    
    @IBAction func couponTouched(_ sender: Any) {
        picker = UIPickerView(frame: CGRect(x: 0, y: Int(UIScreen.main.bounds.height) - 300, width: Int(UIScreen.main.bounds.width), height: 300))
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        self.view.addSubview(picker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: Int(UIScreen.main.bounds.height) - 300, width: Int(UIScreen.main.bounds.width), height: 50))
        toolBar.barStyle = .black
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(couponPicked))]
        self.view.addSubview(toolBar)
    }
    
    @objc func couponPicked(_ sender: Any) {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCoupon.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(listOfCoupon[row].code) (-\(listOfCoupon[row].discount)%"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.couponTextField.text = listOfCoupon[row].code
        updateCoupon(row)
        currentCoupon = listOfCoupon[row]
    }
    
    func updateCoupon(_ index: Int) { // index is the position of Coupon in listOfCoupon
        var strPrice = priceLabel.text ?? "0"
        strPrice.remove(at: strPrice.index(before: strPrice.endIndex)) // remove 'đ' charecter
        self.discountLabel.text = "-\((listOfCoupon[index].discount/100) * (Double(strPrice) ?? 0.0))đ"
        updatePrice(2)
    }
    
    @IBAction func bookTouched(_ sender: Any) {
        var strPrice = priceLabel.text ?? "0"
        strPrice.remove(at: strPrice.index(before: strPrice.endIndex)) // remove 'đ' charecter
        var strTotalPrice = totalPriceLabel.text ?? "0"
        strTotalPrice.remove(at: strTotalPrice.index(before: strTotalPrice.endIndex))// remove 'đ' charecter
        
        //Create a ticket
        let ticket = Ticket(id: "\(route.id)#email of user#\(Date().timeIntervalSinceReferenceDate)",account: "email of user", passengerName: passengerNameTextField.text ?? "", idCard: idCardTextField.text ?? "", phone: phoneTextField.text ?? "", pickUpAddress: pickupAddressTextField.text ?? "", route: route.id, seats: [], coupon: couponTextField.text ?? "", price: Int(strPrice) ?? 0, totalPrice: Int(strTotalPrice) ?? 0, paymentMethod: 0)
        for i in 0...45 {
            if listOfSeat[i].isSelected {
                ticket.seats.append(i)
                route.seats[i] = false
            }
        }
        if iBankingButton.isEnabled == false {
            ticket.paymentMethod = 1
        }
        
        //Check info of ticket
        if (ticket.account == "" || ticket.passengerName == "" || ticket.idCard == "" || ticket.phone == "") {
            //Passenger's information is incomplete
            let alert = UIAlertController(title: "Unsuccessful ticket booking.", message: "Please fill in all required information.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (ticket.seats.count == 0) {
            //Have no seat is selected
            let alert = UIAlertController(title: "Unsuccessful ticket booking.", message: "Please select at least 1 seat to complete your booking.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            //Ticket booking successfully
            
            //Change the route (Update list of seats) on the Firestore
            var db: Firestore!
            db = Firestore.firestore()
            let routeRef = db.collection("Route").document(self.route.id)
            routeRef.updateData([
                "seats": self.route.seats
            ]) { err in
                if let err = err {
                    print("Error when updating data of Route: \(err)")
                } else {
                    print("Route update successfully.")
                }
            }
            
            //Upload the Ticket onto Firestore
            do {
                // Endcode
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(ticket)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
                db.collection("Ticket").document(ticket.id).setData(json)
            } catch let error {
                print("Error writing ticket to Firestore: \(error)")
            }
            
            //Show TicketInfoViewController
            let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "ticketInfoViewController") as! TicketInfoViewController
            vc.ticket = ticket
            vc.garage = garage
            vc.route = route
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
