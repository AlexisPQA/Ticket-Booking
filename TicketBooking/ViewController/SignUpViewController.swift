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
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.setTitle("Sign up   \u{2794}", for: .normal)
        Utilities.styleTextField(fullNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(phoneNumberTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(addressTextField)
        Utilities.styleFilledButton(signUpBtn)
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
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error != nil{
                            let alert = UIAlertController(title: "Creating User", message: "Can't create user", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            let db = Firestore.firestore()
                            db.collection("users").addDocument(data: ["UID":result!.user.uid,"FullName":fullName,"Phone":phone,"Address": Address], completion: { (error) in
                                let alert = UIAlertController(title: "Error while creating user inffo", message: "Something went wrong", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            })
                            let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                            self.view.window?.rootViewController = HomeVC
                            self.view.window?.makeKeyAndVisible()
                        }
                    }
                }
    }
}
