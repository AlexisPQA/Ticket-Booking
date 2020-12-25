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
    @IBOutlet weak var rectangle: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var datePicker: UIButton!
    @IBOutlet weak var couponsPicker: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleView(rectangle)
        Utilities.styleTextField1(fromTextField)
        Utilities.styleTextField1(toTextField)
        Utilities.styleFilledButton(datePicker, 2)
        Utilities.styleFilledButton(couponsPicker, 2)
        let db = Firestore.firestore()
        db.collection("BusStation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bus", for: indexPath) as! BusStationCollectionViewCell

        cell.backgroundColor = UIColor.white
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16).cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 2.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        cell.layer.cornerRadius = 6
        cell.avatar.image = UIImage(named: "google")
        cell.name.text = "BX Miền Tây"
        cell.address.text = "395 Kinh Dương Vương, An Lạc, Bình Tân, Thành Phố Hồ Chí Minh"
        //cell.address.text = "ABXYZ"
        cell.RatingStar.settings.filledColor = UIColor(red: 255/255, green: 210/255, blue: 108/255, alpha: 1)
        cell.RatingStar.rating = 3.7
        
        
        return cell
    }
}
