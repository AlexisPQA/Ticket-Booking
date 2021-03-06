//
//  AccountViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/21/20.
//

import UIKit
import Firebase

class AccountViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var PersonalInfo: UIView!
    @IBOutlet weak var yourTicket: UICollectionView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var idcard: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var yourTicketLabel: UILabel!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var listTicket: [Ticket] = []
    var listOfRoute: [Route] = []
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        print(USER.permission)
        Utilities.styleFloatButton(logOutBtn)
        logOutBtn.backgroundColor = Utilities.mainColor
        Utilities.styleFloatButton(signInBtn)
        signInBtn.backgroundColor = .white
        Utilities.styleView(PersonalInfo,UIColor.white)
        Utilities.styleView(yourTicket,UIColor.white)
        if (USER.permission) == 0{
            logOutBtn.isHidden = true
            userName.isHidden = true
            PersonalInfo.isHidden = true
            yourTicket.isHidden = true
            yourTicketLabel.isHidden = true
            personalInfoLabel.isHidden = true
            signInBtn.isHidden = false
        }
        else{
            signInBtn.isHidden = true
            PersonalInfo.isHidden = false
            yourTicket.isHidden = false
            yourTicketLabel.isHidden = false
            personalInfoLabel.isHidden = false
            userName.text = USER.name
            email.text = "Email   : " + USER.email
            phone.text = "Phone  : " + USER.phone
            idcard.text = "ID Card : " + USER.idCard
            address.text = "Address: " + USER.address
        }
        getTicket()
        //getRoute()
        
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
                                self.yourTicket.reloadData()
                            }
                        }
                    }
                    self.listTicket.append(loadedTicket)
                    print(self.listTicket)
                    self.yourTicket.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
//        let LoginVC = storyboard?.instantiateViewController(identifier: "Login") as! LoginViewController
//        self.navigationController?.pushViewController(LoginVC, animated: true)
//        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Login")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
          do {
            try firebaseAuth.signOut()
            USER = User(permission: 0)
          } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
          }
        self.viewDidLoad()
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
