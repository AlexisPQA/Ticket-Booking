//
//  SearchViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/21/20.
//

import UIKit
import Firebase

class SearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    override func viewDidAppear(_ animated: Bool) {
        ButtonCollection.reloadData()
        StationCollection.reloadData()
        ButtonCollection.reloadData()
        btnSelected.removeAll()
    }

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var GaragesCollection: UICollectionView!
    @IBOutlet weak var ButtonCollection: UICollectionView!
    @IBOutlet weak var StationCollection: UICollectionView!
    @IBOutlet weak var sationsLabel: UILabel!
    @IBOutlet weak var GarageLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let Btn = ["All","Station","Garage","Location"]
    var btnSelected :[IndexPath] = []
    let formatter = DateFormatter()
    var listOfGaragesFixed: [Garage] = []
    var listOfStationFixed: [BusStation] = []
    var listOfGarages: [Garage] = []
    var listOfStation: [BusStation] = []
    var db: Firestore!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        Utilities.styleTextField1(searchTextField)
        
        getListOfGarage()
        getListOfStation()
        ButtonCollection.allowsMultipleSelection = false
        
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
                    
                    // Load thmbnail image for Garage
//                    let pathReference = self.storage.reference(withPath: "Garage/\(loadedGarage.id)")
//                    pathReference.getData(maxSize: 1 * 6000 * 6000) { data, error in
//                        if let error = error {
//                            print(error)
//                        } else {
//                            loadedGarage.avatar = UIImage(data: data!)!
//                        }
//                        self.listOfGarages.append(loadedGarage)
//                        self.GaragesCollection.reloadData()
//                    }
                    self.listOfGarages.append(loadedGarage)
                    self.listOfGaragesFixed.append(loadedGarage)
                    self.GaragesCollection.reloadData()
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
                    self.listOfStationFixed.append(loadedStation)
                    self.StationCollection.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ButtonCollection{
            return Btn.count
        }
        if collectionView == GaragesCollection{
            return listOfGarages.count
        }
        return listOfStation.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == ButtonCollection){
            let cell = collectionView.cellForItem(at: indexPath) as! ButtonFilterCollectionViewCell
            let cellSelected = collectionView.cellForItem(at: btnSelected[0]) as! ButtonFilterCollectionViewCell
            cellSelected.fakeBtn.layer.backgroundColor = .none
            btnSelected.removeAll()
            cell.fakeBtn.layer.backgroundColor = Utilities.mainColor.cgColor
            btnSelected.append(indexPath)
        }else
        if (collectionView == GaragesCollection){
            let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "garageInfoViewController") as! GarageInfoViewController
            vc.garage = listOfGarages[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "stationInfoViewController") as! StationInfoViewController
            vc.station = listOfStation[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == ButtonCollection){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "btnfilter", for: indexPath) as! ButtonFilterCollectionViewCell
            if (indexPath.row == 0){
                cell.fakeBtn.layer.backgroundColor = Utilities.mainColor.cgColor
                btnSelected.append(indexPath)
            }
            cell.fakeBtn.text = Btn[indexPath.item]
            return cell
        }
        if( collectionView == GaragesCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listgarage", for: indexPath) as!GarageSearchCollectionViewCell
            if(listOfGarages.count != 0){
                cell.avatar.image = listOfGarages[indexPath.row].avatar
                cell.name.text = listOfGarages[indexPath.row].name
                cell.station.text = listOfGarages[indexPath.row].busStation
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liststation", for: indexPath) as!StationSearchCollectionViewCell
        if(listOfStation.count != 0){
            cell.name.text = listOfStation[indexPath.row].name
            cell.address.text = listOfStation[indexPath.row].address
        }
        return cell
    }
    
    @IBAction func Search(_ sender: Any) {

        let textsearch = searchTextField.text!.lowercased()
        
        filter(btnSelected[0].row, textsearch)
        StationCollection.reloadData()
        GaragesCollection.reloadData()
        if (textsearch == ""){
            self.listOfGarages = self.listOfGaragesFixed
            self.listOfStation = self.listOfStationFixed
            StationCollection.reloadData()
            GaragesCollection.reloadData()
        }
    }
    
    func filter(_ filter: Int,_ textSearch: String){
        switch filter{
        case 1:
            searchByStation(textSearch)
            break
        case 2:
            searchByGrage(textSearch)
            break
        case 3:
            searchByLocation(textSearch)
            break
        default:
            self.listOfStation = self.listOfStationFixed
            self.listOfGarages = self.listOfGaragesFixed
            searchByAll(textSearch)
            break
        }
    }
    func searchByAll(_ textsearch: String){
        self.listOfStation.removeAll()
        self.listOfStationFixed.forEach { (station) in
            if (station.address.lowercased().contains(textsearch) ||
                station.name.lowercased().contains(textsearch) ||
                station.manager.lowercased().contains(textsearch) ||
                station.openTime.lowercased().contains(textsearch) ||
                station.utilitiesIncluded.lowercased().contains(textsearch)
            )
            {
                self.listOfStation.append(station)
            }
        }
        self.listOfGarages.removeAll()
        self.listOfGaragesFixed.forEach { (garage) in
            if (garage.address.lowercased().contains(textsearch) ||
                garage.name.lowercased().contains(textsearch) ||
                garage.openTime.lowercased().contains(textsearch) ||
                garage.ticketPrice.lowercased().contains(textsearch)
            )
            {
                self.listOfGarages.append(garage)
            }
        }
    }
    func searchByStation(_ textsearch: String){
        self.listOfStation.removeAll()
        self.listOfStationFixed.forEach { (station) in
            if (station.name.lowercased().contains(textsearch)){
                self.listOfStation.append(station)
            }
        }
        
        self.listOfGarages.removeAll()
        self.listOfGaragesFixed.forEach { (garage) in
            if (garage.busStation.lowercased().contains(textsearch)){
                self.listOfGarages.append(garage)
            }
        }
    }
    func searchByGrage(_ textsearch: String){
        self.listOfStation.removeAll()
        self.listOfGarages.removeAll()
        self.listOfGaragesFixed.forEach { (garage) in
            if (garage.name.lowercased().contains(textsearch)){
                self.listOfGarages.append(garage)
            }
        }
    }
    func searchByLocation(_ textsearch: String){
        self.listOfStation.removeAll()
        self.listOfStationFixed.forEach { (station) in
            if (station.address.lowercased().contains(textsearch)){
                self.listOfStation.append(station)
            }
        }
        
        self.listOfGarages.removeAll()
        self.listOfGaragesFixed.forEach { (garage) in
            if (garage.address.lowercased().contains(textsearch.lowercased())){
                self.listOfGarages.append(garage)
            }
        }
    }
}
