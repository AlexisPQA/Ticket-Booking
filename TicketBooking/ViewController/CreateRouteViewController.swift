//
//  CreateRouteViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/21/21.
//

import UIKit
import Firebase

class CreateRouteViewController: UIViewController {
    
    @IBOutlet var listOfSeat: [UIButton]!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var departureTimeTextField: UITextField!
    @IBOutlet weak var licenseplateTextField: UITextField!
    @IBOutlet weak var ticketpriceTextField: UITextField!
    
    var garage = Garage()
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create Route"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped)), animated: true)
        self.navigationController?.navigationBar.tintColor = .black
        
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
    }
    
    func getListOfSeats() -> [Bool] {
        var result : [Bool] = []
        for _ in 0...45 {
            result.append(true)
        }
        return result
    }

    @objc func doneTapped(){
        let date = Date()
        let randomID = date.timeIntervalSince1970
        let lof = getListOfSeats()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        
        let newRoute = Route(id: "\(garage.id)_R\(Int(randomID))", garage: self.garage.id, destination: toTextField.text ?? "", license: licenseplateTextField.text ?? "", seats: lof, aSeatPrice: Int(self.ticketpriceTextField.text!) ?? 0, departureTime: dateFormatter.date(from: departureTimeTextField.text!) ?? date)
        
        print("Date: \(dateFormatter.string(from: newRoute.departureTime))")
        db.collection("Route").document()
        do {
            // Endcode
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(newRoute)
            var json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
            json["departureTime"] = dateFormatter.date(from: departureTimeTextField.text!)!.timeIntervalSince1970
            db.collection("Route").document(newRoute.id).setData(json)
        } catch let error {
            print("Error writing ticket to Firestore: \(error)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seatTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = .init(red: 254/255, green: 135/255, blue: 129/255, alpha: 1)
        } else {
            sender.backgroundColor = .init(red: 219/255, green: 229/255, blue: 243/255, alpha: 1)
        }

    }

}
