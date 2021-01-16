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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        signInBtn.setTitle("Sign in   \u{2794}", for: .normal)
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signInBtn,1)
        
    }

    @IBAction func signInTapped(_ sender: Any) {
        let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil{
                       let alert = UIAlertController(title: "", message: error!.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
                        self.view.window?.rootViewController = HomeVC
                        self.view.window?.makeKeyAndVisible()
                    }
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
}

