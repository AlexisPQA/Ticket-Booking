//
//  CreateGarageViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 1/11/21.
//

import UIKit
import Firebase

class CreateGarageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var garageNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var openTimeTextField: UITextField!
    @IBOutlet weak var ticketPriceTextField: UITextField!
    @IBOutlet weak var utilitiesTextField: UITextField!
    @IBOutlet weak var sellersTableView: UITableView!
    @IBOutlet weak var sellerEmailTextField: UITextField!
    @IBOutlet weak var addSellerButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    var station = BusStation()
    var listOfManager : [String] = []

    var db : Firestore!
    let storage = Storage.storage()
    
    override func viewWillAppear(_ animated: Bool) {
        sellersTableView.contentSize.height = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create garage"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .black
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(createGarageSuccessfully))
        
        sellersTableView.delegate = self
        sellersTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var contentSizeTemp = tableView.contentSize
        //Every cell is 30 of height
        contentSizeTemp.height = CGFloat(listOfManager.count * 30)
        tableView.contentSize = contentSizeTemp
        return listOfManager.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sellerTableViewCell") as! SellerTableViewCell
        cell.sellerNameLabel.text = listOfManager[indexPath.row]
        return cell
    }
    
    
    @IBAction func addManagerTouched(_ sender: Any) {
        //Get email from textfield
        //Use email to find account on Firebase
        //Get the name of that user
        //Update permission of User when created the Garage
    }
    
    @objc func createGarageSuccessfully() {
        if ((garageNameTextField.text != nil) && (addressTextField.text != nil) && (openTimeTextField.text != nil) && listOfManager.count > 0) {
            let newGarage = Garage(id: createGarageId(name: garageNameTextField.text!), address: addressTextField.text ?? "", busStation: station.id, name: garageNameTextField.text ?? "", openTime: openTimeTextField.text ?? "", ticketPrice: ticketPriceTextField.text ?? "", rating: 4.0, manager: listOfManager)
            
            // Upload garageImage to Firebse Storage
            let garageImage = thumbnail.image?.jpegData(compressionQuality: 10.0)
            let storageRef = storage.reference().child("Garage/\(newGarage.id)")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageRef.putData(garageImage!, metadata: metaData) { (metaData, error) in
                if let err = error {
                    print(err)
                } else {
                    print("Upload garageImage successfully!")
                }
            }
            
            // Upload newGarage to Firebase
            do {
                // Endcode
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(newGarage)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
                print(json)
                db.collection("Garage").document(newGarage.id).setData(json)
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
        } else {
            let alert = UIAlertController(title: "Create garage unsuccessfully", message: "Please fill in fields which have (*) signal.\n The Garage have at least a manager.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Create id from name
    func createGarageId(name: String) -> String {
        
        var str : String = name
        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        var sID = String(str[str.index(str.startIndex, offsetBy: 0)])
        for i in 1...(str.count - 1) {
            if str[str.index(str.startIndex, offsetBy: (i - 1))] == " " {
                sID += String(str[str.index(str.startIndex, offsetBy: (i - 1))])
            }
        }
        
        var run = true
        var s = sID
        var count = 0
        
        while run {
            db.collection("Garage").document(s).getDocument { (document, error) in
                if let document = document, document.exists {
                    count += 1
                    s = "sID\(count)"
                } else {
                    run = false
                    sID = s
                }
            }
        }
        
        if run == false {
            return sID
        } else {
            return name + sID // This case only appear when program occur error from Firebase
        }
    }

}

class SellerTableViewCell : UITableViewCell {
    @IBOutlet weak var sellerNameLabel: UILabel!
}
