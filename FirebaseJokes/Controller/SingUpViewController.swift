//
//  SingUpViewController.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 16.04.21.
//

import UIKit
import Firebase

class SingUpViewController: UIViewController, UITextFieldDelegate {
    
    private var validate: Validate!
    private var warning: Warning!
    private var cleaner: Cleaner!
    private var ref: DatabaseReference!
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var pasOneTextField: UITextField!
    @IBOutlet private weak var pasOneProgressView: UIProgressView!
    
    @IBOutlet private weak var pasTwoTextField: UITextField!
    @IBOutlet private weak var pasTwoProgressView: UIProgressView!

    @IBOutlet private weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validate = Validate()
        warning = Warning()
        cleaner = Cleaner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cleaner.clearFields(nameTextField, emailTextField, pasOneTextField, pasTwoTextField, pasOneProgressView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            case nameTextField:
                textField.resignFirstResponder()
                emailTextField.becomeFirstResponder()
            case emailTextField:
                textField.resignFirstResponder()
                pasOneTextField.becomeFirstResponder()
            case pasOneTextField:
                textField.resignFirstResponder()
                pasTwoTextField.becomeFirstResponder()
            case pasTwoTextField:
                view.endEditing(true)
            default:
                break
        }
        return true
    }
    
    @IBAction func emailTap(_ sender: UITextField) {
        validate.isEnableSignUp(sender, pasOneTextField, pasTwoTextField, signUp: signUpButton)
    }
    
    @IBAction func pasOneTap(_ sender: UITextField) {
        validate.isValidPassword(pasOneTextField, progressView: pasOneProgressView)
        validate.isEnableSignUp(emailTextField, sender, pasTwoTextField, signUp: signUpButton)
    }
    
    @IBAction func pasTwoTap(_ sender: UITextField) {
        guard let pasOne = pasOneTextField.text, pasOne != "",
              let pasTwo = pasTwoTextField.text, pasTwo != "" else { return }
        
        if pasOne == pasTwo {
            pasTwoProgressView.progress = 1
            pasTwoProgressView.progressTintColor = .green
        }
        validate.isEnableSignUp(emailTextField, pasOneTextField, sender, signUp: signUpButton)
    }
    
    @IBAction private func signUpTap(_ sender: Any) {
        
//        guard let email = emailTextField.text, email != "" else { return }
//        guard let pasOne = pasOneTextField.text, pasOne != "" else { return }
//        guard let pasTwo = pasTwoTextField.text, pasTwo != "" else { return }
//
//        if validate.isValidEmail(email) && ( pasOne == pasTwo ) {
//
//        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}
