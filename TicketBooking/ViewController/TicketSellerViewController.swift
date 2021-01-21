//
//  TicketSellerViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 1/20/21.
//

import UIKit
import Firebase

class TicketSellerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameGarage: UILabel!
    @IBOutlet weak var createRouteBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var requestCollection: UICollectionView!
    @IBOutlet weak var routeCollection: UICollectionView!
    
    var listOfRequest: [Ticket] = []
    var listOfRoute: [Route] = []
    var garage : Garage = Garage()
    var db: Firestore!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleFloatButton(createRouteBtn)
        createRouteBtn.backgroundColor = Utilities.subColor
        Utilities.styleFloatButton(logoutBtn)
        logoutBtn.backgroundColor = Utilities.mainColor
        
        requestCollection.delegate = self
        requestCollection.dataSource = self
        routeCollection.delegate = self
        routeCollection.dataSource = self
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
        
        loadGarage()
        
        self.name.text = USER.name
        

    }
    
    func loadGarage() {
        db.collection("Garage").whereField("manager", arrayContains: USER.email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    self.garage = Garage(document: document)
                    self.loadListOfRoute()
                    self.nameGarage.text = self.garage.name
                    break
                }
            }
        }
    }
    
    func loadListOfRoute() {
        db.collection("Route").whereField("garage", isEqualTo: "\(self.garage.id)").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.listOfRoute.append(Route(document: document))
                }
                self.loadListOfRequest()
                self.routeCollection.reloadData()
            }
        }
    }
    
    func loadListOfRequest() {
        for route in listOfRoute {
            DispatchQueue.main.async {
                self.db.collection("CancelTicketRequest").whereField("route", isEqualTo: route.id).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting CancelRequest documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.listOfRequest.append(Ticket(document: document))
                        }
                        self.requestCollection.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func createRouteTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow3", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "createroute") as! CreateRouteViewController
        vc.garage = self.garage
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
                    self.listOfRequest.append(loadedTicket)
                    print(self.listOfRequest)
                    self.requestCollection.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == routeCollection {
            return listOfRoute.count
        } else {
            return listOfRequest.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ((listOfRequest.count != 0) && (collectionView == requestCollection)) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticket", for: indexPath) as! YourTicketCollectionViewCell
            var route = Route()
            for r in listOfRoute {
                if r.id == listOfRequest[indexPath.row].route {
                    route = r
                    break
                }
            }
            cell.from.text = garage.address
            cell.destination.text = route.destination
            cell.garage.text = "Garage: " + garage.name
            cell.licenseplate.text = "License Plate: " + route.licensePlate
            cell.seat.text = "Seat :"
            listOfRequest[indexPath.item].seats.forEach { (seat) in
                if (seat < 23) {
                    cell.seat.text! += " A\(seat + 1)"
                } else {
                    cell.seat.text! += " B\(seat - 22)"
                }
            }
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            cell.time.text = "Departure Time: " + formatter.string(from: route.departureTime)
            cell.Transshipment.text = "Transshipment: \(listOfRequest[indexPath.row].pickUpAddress)"
            cell.price.text = "\(listOfRequest[indexPath.item].price)đ"
            cell.total.text = "\(listOfRequest[indexPath.item].totalPrice)đ"
            cell.discount.text = "\(listOfRequest[indexPath.item].price - listOfRequest[indexPath.item].totalPrice)đ"
            cell.coupon.text = listOfRequest[indexPath.item].coupon
            
            cell.acceptButton.tag = indexPath.row
            cell.acceptButton.addTarget(self, action: #selector(deleteRowAt(sender:)), for: .touchUpInside)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "routeCollectionViewCell1", for: indexPath) as! RouteCollectionViewCell
            cell.setupRouteCell(listOfRoute[indexPath.row], garage.address)
            return cell
        }
    }
    
    //This function delete cell at index on RequestCancelPending
    @objc func deleteRowAt(sender: UIButton) {
        let index = sender.tag
        db.collection("CancelTicketRequest").document(listOfRequest[index].id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.updateRoute(id: self.listOfRequest[index].route, seats: self.listOfRequest[index].seats)
                self.listOfRequest.remove(at: index)
                self.requestCollection.reloadData()
            }
        }
    }
    
    //id: id of route need to update
    func updateRoute(id: String, seats: [Int]) {
        print("route: \(id)")
//        db.collection("Route").document(id).updateData([
//            "seats": FieldValue.arrayContains
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
    }
    
}
