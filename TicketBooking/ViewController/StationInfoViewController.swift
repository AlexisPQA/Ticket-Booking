//
//  StationInfoViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 12/21/20.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class StationInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var utilitiesIncluedLabel: UILabel!
    @IBOutlet weak var garagesCollectionView: UICollectionView!
    
    var station: BusStation = BusStation()
    var listOfGarages: [Garage] = []
    var db: Firestore!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bus station"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        
        Utilities.styleImageFrame(image)
        
        garagesCollectionView.delegate = self
        garagesCollectionView.dataSource = self
        
        // Tạo ví dụ
        station = BusStation(id: "BXMD", name: "Bến xe Miền Đông", address: "75/22 Tân Lập, Bình Dương", openTime: "24/7", utilities: "WC, parking area, waitting room, canteen", rating: 4.3, manager: "bxmd_admi@gmail.com")
        stationNameLabel.text = station.name
        addressLabel.text = station.address
        openTimeLabel.text = station.openTime
        utilitiesIncluedLabel.text = station.utilitiesIncluded
        
        getListOfGarage()
    }
    
    func getListOfGarage() {
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()

        let docRef = self.db.collection("Garage").whereField("busStation", isEqualTo: "\(self.station.name)")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let loadedGarage = Garage(document: document)
                    
                    // Load thmbnail image for Garage
                    let pathReference = self.storage.reference(withPath: "Garage/\(loadedGarage.id)")
                    pathReference.getData(maxSize: 1 * 6000 * 6000) { data, error in
                        if let error = error {
                        	print(error)
                        } else {
                            loadedGarage.avatar = UIImage(data: data!)!
                        }
                        self.listOfGarages.append(loadedGarage)
                        self.garagesCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfGarages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = garagesCollectionView.dequeueReusableCell(withReuseIdentifier: "garageCollectionViewCell", for: indexPath) as! GarageCollectionViewCell
        
        if (listOfGarages.count != 0) {
            cell.setupGarageCell(listOfGarages[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "garageInfoViewController") as! GarageInfoViewController
        vc.garage = listOfGarages[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dataButton(_ sender: Any) {
        // Ghi dữ liệu lên
        // [START set_document_codable]
        let aGarage = Garage(id: "Test1", address: "A22, Block A", busStation: "Bến xe Miền Tây", name: "Nhà xe Hùng Cường", openTime: "24/7", ticketPrice: "130.000đ - 250.000đ", rating: 4.0, manager: ["abc@gmail.com", "xyz@outlook.com"])
       
        do {
            // Endcode
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(aGarage)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
            print(json)
            db.collection("Garage").document(aGarage.id).setData(json)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
        
        // Get data from Cloud FireStore into Garage object
        let docRef = db.collection("Garage").document("Test1")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let aa = Garage(document: document)
                print("New data: \(aa.name)")
            } else {
                print("Document does not exist")
            }
        }
         
        // Upload an image to storage
        // Create a root reference
        let storageRef = storage.reference().child("Garage/Test3")
        let mockImage = UIImage(named: "mock-image3")?.jpegData(compressionQuality: 10.0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(mockImage!, metadata: metaData) { (metaData, error) in
            if let err = error {
                print(err)
            } else {
                print("Upload successfully!")
            }
        }
        
    }
    
}

class GarageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = thumbnail.frame.width/2
        
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    func setupGarageCell(_ garage : Garage) {
        self.thumbnail.image = garage.avatar
        self.addressLabel.text = garage.address
        self.nameLabel.text = garage.name
    }
}
