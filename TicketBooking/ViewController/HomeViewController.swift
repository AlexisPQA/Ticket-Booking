//
//  HomeViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/21/20.
//

import UIKit
import Cosmos
import Firebase

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            let u = Auth.auth().currentUser
            getUserFromFireBasse((u?.email!)!)
        }
    }
    @IBOutlet weak var rectangle: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var datePickerBtn: UIButton!
    @IBOutlet weak var couponsPicker: UIButton!
    @IBOutlet weak var garagesCollectionView: UICollectionView!
    @IBOutlet weak var busStationCollectionView: UICollectionView!
    let formatter = DateFormatter()
    var listOfGarages: [Garage] = []
    var listOfStation: [BusStation] = []
    var db: Firestore!
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd/MM/yyyy"
        Utilities.styleView(rectangle,Utilities.subColor)
        Utilities.styleTextField1(fromTextField)
        Utilities.styleTextField1(toTextField)
        Utilities.styleFilledButton(datePickerBtn, 2)
        Utilities.styleFilledButton(couponsPicker, 2)
        getListOfGarage()
        getListOfStation()

    }
    
    func getUserFromFireBasse(_ email: String) {
        Firestore.firestore().settings = FirestoreSettings()
        let db = Firestore.firestore()

        let docRef = db.collection("users").document(email)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let user = document.data()!
                USER = User(email: user["email"] as! String, name: user["name"] as! String, phone: user["phone"] as! String, idCard: user["idCard"] as! String, address: user["address"] as! String, permission: user["permission"] as! Int)
            } else {
                print("Document does not exist")
            }
        }
        print(USER.permission)
    }
    
    
    func getListOfGarage() {
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()

        let docRef = self.db.collection("Garage")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let loadedGarage = Garage(document: document)
                    
//                    // Load thmbnail image for Garage
//                    let pathReference = self.storage.reference(withPath: "Garage/\(loadedGarage.id)")
//                    pathReference.getData(maxSize: 1 * 6000 * 6000) { data, error in
//                        if let error = error {
//                            print(error)
//                        } else {
//                            loadedGarage.avatar = UIImage(data: data!)!
//                        }
//                        self.listOfGarages.append(loadedGarage)
//                        self.garagesCollectionView.reloadData()
//                    }
                    self.listOfGarages.append(loadedGarage)
                    self.garagesCollectionView.reloadData()
                }
            }
        }
    }
    
    func getListOfStation() {
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()

        let docRef = self.db.collection("BusStation")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let loadedStation = BusStation(document: document)
                    
                    self.listOfStation.append(loadedStation)
                    self.busStationCollectionView.reloadData()
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == garagesCollectionView){
            return listOfGarages.count
        }
        return listOfStation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if( collectionView == garagesCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "garage", for: indexPath) as!BusStationCollectionViewCell
            if(listOfGarages.count != 0){
                cell.avatar.image = listOfGarages[indexPath.row].avatar
                cell.name.text = listOfGarages[indexPath.row].name
                cell.address.text = listOfGarages[indexPath.row].address
                cell.RatingStar.settings.filledColor = UIColor(red: 255/255, green: 210/255, blue: 108/255, alpha: 1)
                cell.RatingStar.rating = listOfGarages[indexPath.row].rating
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bus", for: indexPath) as!BusStationCollectionViewCell
        if(listOfStation.count != 0){
            cell.name.text = listOfStation[indexPath.row].name
            cell.address.text = listOfStation[indexPath.row].address
            cell.RatingStar.settings.filledColor = UIColor(red: 255/255, green: 210/255, blue: 108/255, alpha: 1)
            cell.RatingStar.rating = listOfStation[indexPath.row].rating
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == garagesCollectionView){
            let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "garageInfoViewController") as! GarageInfoViewController
            vc.garage = listOfGarages[indexPath.row]
            //self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
        }
        else{
            let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "stationInfoViewController") as! StationInfoViewController
            vc.station = listOfStation[indexPath.row]
            //self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
        @IBAction func datePickerTapped(_ sender: Any) {
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
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        if let date = sender?.date {
            let pickedDate = formatter.string(from: date)
            self.datePickerBtn.setTitle("  \(pickedDate)", for: .normal)
        }
    }
    @IBAction func couponsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow3", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "showallrequest")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
