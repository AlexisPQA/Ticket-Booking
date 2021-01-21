//
//  ShowAllRequestViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/21/21.
//

import UIKit
import Firebase

class ShowAllRequestViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var RequestCollection: UICollectionView!
    
    var listTicket: [Ticket] = []
    var listOfRoute: [Route] = []
    var db: Firestore!
    
    @IBAction func fromTextField(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Request Cancel Ticket"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        getTicket()
        
    }
    

    func getTicket() {
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()

        let docRef = self.db.collection("Ticket").whereField("account", isEqualTo: "\(USER.email)")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let loadedTicket = Ticket(document: document)
                    let RouteRef = self.db.collection("Route").whereField("id", isEqualTo: "\(loadedTicket.route)")
                    RouteRef.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let loadedRoute = Route(document: document)
                                self.listOfRoute.append(loadedRoute)
                                print(self.listOfRoute)
                                self.RequestCollection.reloadData()
                            }
                        }
                    }
                    self.listTicket.append(loadedTicket)
                    print(self.listTicket[0].account)
                    self.RequestCollection.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if( listTicket.count != 0 && listOfRoute.count != 0){
            return listTicket.count
        }
        
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if( listTicket.count != 0 && listOfRoute.count != 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "request", for: indexPath) as! YourTicketCollectionViewCell
            cell.from.text = listTicket[indexPath.item].pickUpAddress
            cell.destination.text = listOfRoute[indexPath.item].destination
            cell.garage.text = "Garage :" + listOfRoute[indexPath.item].garage
            cell.licenseplate.text = "License Plate :" + listOfRoute[indexPath.item].licensePlate
            cell.seat.text = "Seat :"
            listTicket[indexPath.item].seats.forEach { (seat) in
                cell.seat.text! += "\(seat)"
            }
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            cell.time.text = formatter.string(from: listOfRoute[indexPath.item].departureTime)
            cell.Transshipment.text = "Yes"
            cell.price.text = "\(listTicket[indexPath.item].price)"
            cell.total.text = "\(listTicket[indexPath.item].totalPrice)"
            cell.discount.text = "Transshipment: No"
            cell.coupon.text = listTicket[indexPath.item].coupon
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "request", for: indexPath) as! YourTicketCollectionViewCell
        return cell
    }

}
