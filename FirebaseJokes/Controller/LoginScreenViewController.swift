//
//  LoginScreenViewController.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit

class LoginScreenViewController: UIViewController {
    
    private var helper = HelperСlass()
    
    @IBOutlet private weak var warningLabel: UILabel!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var progressViewPassword: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func emailTextFieldTap(_ sender: UITextField) {
        
        guard let email = emailTextField.text, email != "" else { return }
        if helper.isValidEmail(email) {
            helper.displayWarningLabel(warningLabel: warningLabel, withText: "Your email is correct")
        }
    }
    
    @IBAction private func passwordTextFieldTap(_ sender: UITextField) {
        
        helper.isValidPassword(sender, progressView: progressViewPassword)
    }
    
    @IBAction private func singInTap() {
        
        performSegue(withIdentifier: "toJokes", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    private func clearFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        progressViewPassword.progress = 0
    }
}
