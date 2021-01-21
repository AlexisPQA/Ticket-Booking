//
//  GarageInfoViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit
import Firebase
import FirebaseStorage

class GarageInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var garageNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var routesCollectionView: UICollectionView!
    
    var db : Firestore!
    var garage : Garage = Garage()
    var listOfRoute : [Route] = []
    var allRoutes : [Route] = []
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Garage"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        self.navigationController?.navigationBar.backgroundColor = Utilities.mainColor
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeTapped)), animated: true)
        self.navigationController?.navigationBar.tintColor = .black
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        Utilities.styleImageFrame(image)
        Utilities.styleFloatButton(dateButton)
        
        routesCollectionView.delegate = self
        routesCollectionView.dataSource = self
        
        self.image.image = garage.avatar
        self.garageNameLabel.text = garage.name
        self.addressLabel.text = garage.address
        self.stationNameLabel.text = garage.busStation
        self.openTimeLabel.text = garage.openTime
        self.ticketPriceLabel.text = garage.ticketPrice
        let today = formatter.string(from: Date())
        self.dateButton.setTitle("  \(today)", for: .normal)
        
        getListOfRoute()
    }
    
    @objc func homeTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getListOfRoute() {
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
        
        let docRef = self.db.collection("Route").whereField("garage", isEqualTo: "\(self.garage.id)")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.listOfRoute.append(Route(document: document))
                }
                self.allRoutes = self.listOfRoute
                self.checkDateForListOfRoute()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfRoute.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = routesCollectionView.dequeueReusableCell(withReuseIdentifier: "routeCollectionViewCell", for: indexPath) as! RouteCollectionViewCell
        
        cell.setupRouteCell(listOfRoute[indexPath.row], garage.address)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (USER.permission == 0) {
            let alert = UIAlertController(title: "", message: "Plese sign in to book a ticket.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "ticketBookingViewController") as! TicketBookingViewController
            vc.route = listOfRoute[indexPath.row]
            vc.garage = garage
            self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    @IBAction func showDatePicker(_ sender: Any) {
        datePicker.backgroundColor = UIColor.white
        datePicker.preferredDatePickerStyle = .compact

        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date

        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(datePicker)

        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.items = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.hideDatePicker))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @objc func hideDatePicker() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        checkDateForListOfRoute()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        if let date = sender?.date {
            let pickedDate = formatter.string(from: date)
            self.dateButton.setTitle("  \(pickedDate)", for: .normal)
        }
    }
    
    func checkDateForListOfRoute() {
        let str: String = self.dateButton.currentTitle!.trimmingCharacters(in: .whitespacesAndNewlines)
        formatter.dateFormat =  "dd/MM/yyyy HH:mm"
        formatter.locale = Locale.init(identifier:"en_US_POSIX")
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
        let date = formatter.date(from: "\(str) 00:00")
        formatter.dateFormat =  "dd/MM/yyyy"
        
        self.listOfRoute.removeAll()
        for route in allRoutes {
            if route.departureTime.compare(date!).rawValue >= 0  {
                self.listOfRoute.append(route)
            }
        }
        
        self.routesCollectionView.reloadData()
    }
    
    @IBAction func dataButton(_ sender: Any) {
//        let mockSeats = [Bool](repeating: true, count: 46)
//        let mockRoute = Route(id: "NXHC_R002", garage: "Test2", destination: "Vĩnh Long", license: "50A-38766", seats: mockSeats, aSeatPrice: 100000, departureTime: Date())
//
//        do {
//            // Endcode
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(mockRoute)
//            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
//            print(json)
//            db.collection("Route").document(mockRoute.id).setData(json)
//        } catch let error {
//            print("Error writing city to Firestore: \(error)")
//        }
        
        
    }
    
}

class RouteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 6.0
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 1)

        layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.16
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    func setupRouteCell(_ route: Route, _ from: String) {
        fromLabel.text = from
        toLabel.text = route.destination
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        timeLabel.text = formatter.string(from: route.departureTime)
        dateLabel.text = "\(Calendar.current.component(.hour, from: route.departureTime)):\(Calendar.current.component(.minute, from: route.departureTime))"
    }
}
