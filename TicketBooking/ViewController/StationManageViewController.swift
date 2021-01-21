//
//  StationManageViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 1/11/21.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class StationManageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var managerNameLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var garagesCollectionView: UICollectionView!
    @IBOutlet weak var couponsCollectionView: UICollectionView!
    @IBOutlet weak var createGarageButton: UIButton!
    @IBOutlet weak var createCouponButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var station = BusStation()
    var listOfGarages : [Garage] = []
    var listOfCoupon : [Coupon] = []
    
    var db : Firestore!
    let storage = Storage.storage()
    
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

        Utilities.styleFloatButton(createGarageButton)
        Utilities.styleFloatButton(createCouponButton)
        Utilities.styleFloatButton(logOutButton)
        
        garagesCollectionView.delegate = self
        garagesCollectionView.dataSource = self
        couponsCollectionView.delegate = self
        couponsCollectionView.dataSource = self
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
        
        loadStation()
        loadCoupons()
    }
    
    //Load station info from Firebase base on email of user
    func loadStation() {
        let docRef = self.db.collection("BusStation").whereField("manager", isEqualTo: "\(USER.email)")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.station = BusStation(document: document)
                    self.loadGarages()
                }
            }
        }
    }
    
    //Load garages from Firebase and fill in the listOfGarages
    func loadGarages() {
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
    
    //Load all of Coupon from Firebase and fill in the listOfCoupons
    func loadCoupons() {
        db.collection("Coupon").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let coupon = Coupon(document: document)
                    self.listOfCoupon.append(coupon)
                }
                self.couponsCollectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case garagesCollectionView:
            return listOfGarages.count
        case couponsCollectionView:
            return listOfCoupon.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case garagesCollectionView:
            let cell = garagesCollectionView.dequeueReusableCell(withReuseIdentifier: "garageCollectionViewCell", for: indexPath) as! GarageCollectionViewCell
            if (listOfGarages.count != 0) {
                cell.setupGarageCell(listOfGarages[indexPath.row])
            }
            return cell
            
        default: //couponsCollectionView
            let cell = couponsCollectionView.dequeueReusableCell(withReuseIdentifier: "couponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
            if (listOfCoupon.count != 0) {
                cell.setupCouponCell(listOfCoupon[indexPath.row])
            }
            return cell
        }
    }
    @IBAction func createGarageTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow2", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "createGarageViewController") as! CreateGarageViewController
        vc.station = self.station
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func createCouponTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow2", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "createCouponViewController") as! CreateCouponViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logOutTouched(_ sender: Any) {
        print("Loged out.")
        self.navigationController?.popToRootViewController(animated: true)
    }
}

class CouponCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var efdLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    func setupCouponCell(_ coupon: Coupon) {
        self.codeLabel.text = coupon.code
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.efdLabel.text = formatter.string(from: coupon.EFD)
        self.expLabel.text = formatter.string(from: coupon.EXP)
        self.discountLabel.text = "\(coupon.discount)"
    }
}
