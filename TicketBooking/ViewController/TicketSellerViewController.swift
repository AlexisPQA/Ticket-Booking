//
//  TicketSellerViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/20/21.
//

import UIKit
import Firebase

class TicketSellerViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameGarage: UILabel!
    @IBOutlet weak var createRouteBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var requestCollection: UICollectionView!
    
    var listTicket: [Ticket] = []
    var listOfRoute: [Route] = []
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        Utilities.styleFilledButton(createRouteBtn, 2)
        Utilities.styleFilledButton(logoutBtn, 1)

    }
    @IBAction func showAllTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow3", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "showallrequest")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func createRouteTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow3", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "createroute")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
          do {
            try firebaseAuth.signOut()
            USER = User(permission: 0)
            self.navigationController?.popViewController(animated: true)
          } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
          }
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
                                self.requestCollection.reloadData()
                            }
                        }
                    }
                    self.listTicket.append(loadedTicket)
                    print(self.listTicket)
                    self.requestCollection.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if( listTicket.count != 0 && listOfRoute.count != 0){
            return listTicket.count
        }
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if( listTicket.count != 0 && listOfRoute.count != 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticket", for: indexPath) as! YourTicketCollectionViewCell
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
            cell.time.text = "Departure Time: " + formatter.string(from: listOfRoute[indexPath.item].departureTime)
            cell.Transshipment.text = "Transshipment: Yes"
            cell.price.text = "\(listTicket[indexPath.item].price)"
            cell.total.text = "\(listTicket[indexPath.item].totalPrice)"
            cell.discount.text = "No"
            cell.coupon.text = listTicket[indexPath.item].coupon
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticket", for: indexPath) as! YourTicketCollectionViewCell
        return cell
    }
}
