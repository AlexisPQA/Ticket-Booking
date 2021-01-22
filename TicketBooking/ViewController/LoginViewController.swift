//
//  ViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/19/20.
//

import UIKit
import Firebase

var USER = User(permission: 0)

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    var db :Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)

        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = Utilities.mainColor
        
        signInBtn.setTitle("Sign in   \u{2794}", for: .normal)
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signInBtn,1)
        
        Firestore.firestore().settings = FirestoreSettings()
        db = Firestore.firestore()
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
    
    @IBAction func signInTapped(_ sender: Any) {
        let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        DispatchQueue.main.async {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil{
                       let alert = UIAlertController(title: "", message: error!.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let user = Auth.auth().currentUser
                        DispatchQueue.main.async {
                        user?.reload(completion: { (error) in
                            if ((user?.isEmailVerified) != true){
                                user?.sendEmailVerification(completion: { (error) in
                                    if (error != nil){
                                        print(error!)
                                    }
                                })
                                 let alert = UIAlertController(title: "", message: "Activation link sent to email ID. Please activate to log in.", preferredStyle: .alert)
                                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                 self.present(alert, animated: true, completion: nil)
                            let firebaseAuth = Auth.auth()
                              do {
                                try firebaseAuth.signOut()
                              } catch let signOutError as NSError {
                                print ("Error signing out: %@", signOutError)
                              }
                                
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.db.collection("users").document((user?.email)!).getDocument { (document, error) in
                                        if let document = document, document.exists {
                                            USER = User(document: document)
                                            print("Choose permission \(USER.permission)")
                                            self.showView()
                                        } else {
                                            print("Document does not exist")
                                        }
                                    }
                                }
                            }
                        })
                    }
                        
                    }
                }
        }
    }
    
    func showView() {
        switch USER.permission {
        case 2:
            let storyboard = UIStoryboard(name: "Flow3", bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "ticketsellervc") 
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "Flow2", bundle: nil)
            let managerVC = storyboard.instantiateViewController(withIdentifier: "stationManageViewController")
            self.navigationController?.pushViewController(managerVC, animated: true)
        default:
            
            let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
            self.view.window?.rootViewController = HomeVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
                self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func nguyenTestButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow1", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "stationInfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nguyenTestFlow2(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow2", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "stationManageViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func flow3(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Flow3", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ticketsellervc")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

