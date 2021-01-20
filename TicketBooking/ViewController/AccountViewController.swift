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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(USER.permission)
        Utilities.styleFilledButton(logOutBtn, 1)
        Utilities.styleFilledButton(signInBtn, 2)
        Utilities.styleView(PersonalInfo,UIColor.white)
        Utilities.styleView(yourTicket,UIColor.white)
        if (USER.permission) == 1{
            logOutBtn.isHidden = true
            userName.isHidden = true
            PersonalInfo.isHidden = true
            yourTicket.isHidden = true
            yourTicketLabel.isHidden = true
            personalInfoLabel.isHidden = true
        }
        else{
            signInBtn.isHidden = true
            userName.text = USER.name
            email.text = "Email   : " + USER.email
            phone.text = "Phone  : " + USER.phone
            idcard.text = "ID Card : " + USER.idCard
            address.text = "Address: " + USER.address
        }
        
        
    }
    @IBAction func signInTapped(_ sender: Any) {
        let LoginVC = storyboard?.instantiateViewController(identifier: "Login") as! LoginViewController
        self.navigationController?.pushViewController(LoginVC, animated: true)
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
          do {
            try firebaseAuth.signOut()
            USER = User(permission: 0)
          } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
          }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticket", for: indexPath) as! YourTicketCollectionViewCell
//        cell.backgroundColor = UIColor.white
//        cell.layer.backgroundColor = UIColor.white.cgColor
//        cell.layer.shadowColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16).cgColor
//        cell.layer.shadowOffset = CGSize(width: 3, height: 2.0)//CGSizeMake(0, 2.0);
//        cell.layer.shadowRadius = 5.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
//        cell.layer.cornerRadius = 6
        //cell.from.text = "Hello"
        return cell
    }
    
}
