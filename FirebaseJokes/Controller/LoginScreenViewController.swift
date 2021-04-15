//
//  LoginScreenViewController.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit
import Firebase

class LoginScreenViewController: UIViewController {
    
    private var validate: Validate!
    private var warning: Warning!
    private var ref: DatabaseReference!
    
    @IBOutlet private weak var warningLabel: UILabel!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var progressViewPassword: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        validate = Validate()
        warning = Warning()
        
        ref = Database.database().reference(withPath: "users")
        
        //Если у нас еще есть действующий user, то сделаем переход
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: Segue.jokes, sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearFields()
    }
    
    @IBAction private func emailTextFieldTap(_ sender: UITextField) {
        
        guard let email = emailTextField.text, email != "" else { return }
        if validate.isValidEmail(email) {
            warning.displayWarningLabel(warningLabel: warningLabel, withText: "Your email is correct")
        }
    }
    
    @IBAction private func passwordTextFieldTap(_ sender: UITextField) {
        
        validate.isValidPassword(sender, progressView: progressViewPassword)
    }
    
    @IBAction private func singInTap() {
        guard let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != "" else {
            warning.displayWarningLabel(warningLabel: warningLabel, withText: "Info is not correct")
            return
        }
        
        //Логинит пользователя если он существует
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.warning.displayWarningLabel(warningLabel: self!.warningLabel, withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: Segue.jokes, sender: nil)
                return
            }
            
            self?.warning.displayWarningLabel(warningLabel: self!.warningLabel, withText: "No such user")
        }
    }
    
    @IBAction private func singUpTap(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != "" else {
            warning.displayWarningLabel(warningLabel: warningLabel, withText: "Info is not correct")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                self?.warning.displayWarningLabel(warningLabel: self!.warningLabel, withText: error!.localizedDescription)
                return
            }
            guard let user = user else { return }
            let userRef = self?.ref.child(user.user.uid)
            userRef?.setValue(["email" : user.user.email])
        }
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
