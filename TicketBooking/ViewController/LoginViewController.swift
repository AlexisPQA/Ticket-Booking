//
//  ViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/19/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.setTitle("Sign in   \u{2794}", for: .normal)
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signInBtn)
    }

    @IBAction func signInTapped(_ sender: Any) {
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    }
}

