//
//  SignUpViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/21/20.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var idcardTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = Utilities.mainColor
        
        signUpBtn.setTitle("Sign up   \u{2794}", for: .normal)
        Utilities.styleTextField(fullNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(phoneNumberTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(addressTextField)
        Utilities.styleFilledButton(signUpBtn,1)
        Utilities.styleTextField(idcardTextField)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    func checkValidateField()->Int?{
            if fullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return 1
            }
            if Utilities.isPasswordValid(passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
                return 2
            }
            
            return nil
        }

    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = checkValidateField()
                
                if error != nil{
                    if error == 1{
                        let alert = UIAlertController(title: "", message: "Please fill in all fields", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    if error == 2{
                        let alert = UIAlertController(title: "Password is not secure enough", message: "Make sure your password is at least  8 characters, contain special character and a number", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let fullName = fullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let phone = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let Address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let idcard = idcardTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "Creating User Error", message: "Can't create user", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            let db = Firestore.firestore()
                            let  user = User(email: email, name: fullName, phone: phone, idCard: idcard, address: Address, permission: 1)
                            do {
                                // Endcode
                                let jsonEncoder = JSONEncoder()
                                let jsonData = try jsonEncoder.encode(user)
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
                                print(json)
                                db.collection("users").document(user.email).setData(json)
                            } catch let error {
                                print(error)
                            }
                            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                print(error)
                            })
                            let alert = UIAlertController(title: "", message: "Activation link sent to email ID. Please activate to log in", preferredStyle: .alert)
                            let okActionBtn = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                                  self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(okActionBtn)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
    }
}
