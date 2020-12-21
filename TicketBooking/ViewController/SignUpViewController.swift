//
//  SignUpViewController.swift
//  TicketBooking
//
//  Created by AlexisPQA on 12/21/20.
//

import UIKit

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
    



}
