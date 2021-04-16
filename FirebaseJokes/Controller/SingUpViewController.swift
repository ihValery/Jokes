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
        
        ref = Database.database().reference(withPath: "users")
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
        
        if validate.equalPasswords(pasOneTextField, pasTwoTextField) {
            pasTwoProgressView.progress = 1
            pasTwoProgressView.progressTintColor = .systemGreen
        }
        validate.isEnableSignUp(emailTextField, pasOneTextField, sender, signUp: signUpButton)
    }
    
    @IBAction private func signUpTap(_ sender: Any) {
        guard let email = emailTextField.text,
              let passwordOne = pasOneTextField.text, passwordOne != "",
              let passwordTwo = pasTwoTextField.text, passwordTwo != "" else {
            
            let message = "Знаешь как решить данную проблему? Напиши ihValery@email.com"
            let alert = UIAlertController(title: "А ты хитер )))", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: passwordTwo) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                let alert = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true)
                return
            }
            
            guard let user = user else { return }
            let userRef = self?.ref.child(user.user.uid)
            
            //TODO: - Доделать name
            
            if let name = self?.nameTextField.text, name != "" {
                userRef?.setValue(["email" : user.user.email, "name" : user.user.displayName])
            } else {
                userRef?.setValue(["email" : user.user.email])
            }
            self?.performSegue(withIdentifier: Segue.upJokes, sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}
