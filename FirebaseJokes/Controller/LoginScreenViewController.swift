//
//  LoginScreenViewController.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit
import Firebase

class LoginScreenViewController: UIViewController {
    
    private var helper: HelperСlass!
    private var ref: DatabaseReference!
    
    @IBOutlet private weak var warningLabel: UILabel!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var progressViewPassword: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = HelperСlass()
        
        ref = Database.database().reference(withPath: "users")
        
        //Если у нас еще есть действующий user, то сделаем переход
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "goJokes", sender: nil)
            }
        }

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
        guard let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != "" else {
            helper.displayWarningLabel(warningLabel: warningLabel, withText: "Info is not correct")
            return
        }
        
        //Логинит пользователя если он существует
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.helper.displayWarningLabel(warningLabel: self!.warningLabel, withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "goJokes", sender: nil)
                self?.clearFields()
                return
            }
            
            self?.helper.displayWarningLabel(warningLabel: self!.warningLabel, withText: "No such user")
        }
    }
    
    @IBAction private func singUpTap(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != "" else {
            helper.displayWarningLabel(warningLabel: warningLabel, withText: "Info is not correct")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
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
