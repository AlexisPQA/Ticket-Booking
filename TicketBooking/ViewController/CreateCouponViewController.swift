//
//  CreateCouponViewController.swift
//  TicketBooking
//
//  Created by Thành Nguyên on 1/11/21.
//

import UIKit
import Firebase

class CreateCouponViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var efdTextField: UITextField!
    @IBOutlet weak var expTextField: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    
    var db : Firestore!
    var delegate : updateCollection?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create coupon"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(createCouponSuccessfully))
        self.navigationController?.navigationBar.tintColor = .white
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
        

    }
    
    @objc func createCouponSuccessfully() {
        let coupon = Coupon()
        
        //Check for all TextField must be filled
        if (codeTextField.text == "" || efdTextField.text == "" || expTextField.text == "" || discountTextField.text == "") {
            let alert = UIAlertController(title: "Unsuccessful", message: "Please enter all information in the form.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            coupon.code = codeTextField.text!
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "dd/MM/yyyy"
            coupon.EFD = dateFormatter.date(from: efdTextField.text ?? "")!
            coupon.EXP = dateFormatter.date(from: expTextField.text  ?? "")!
            if let discount = Double(discountTextField.text!) {
                coupon.discount = discount
                do {
                    let jsonEncoder = JSONEncoder()
                    let jsonData = try jsonEncoder.encode(coupon)
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
                    db.collection("Coupon").document(coupon.code).setData(json)
                    print("Create coupon successfully.")
                    delegate!.updateCouponCollection(coupon: coupon)
                    navigationController?.popViewController(animated: true)
                } catch let error {
                    print("Error writing city to Firestore: \(error)")
                }
            } else {
                let alert = UIAlertController(title: "Unsuccessful", message: "'Discount' must be a number with a value between 0 and 100.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
