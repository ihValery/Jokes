//
//  Cleaner.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit

class Cleaner {
    
    ///Clean up text fields for more security.
    func clearFields(_ email: UITextField, _ password: UITextField, _ progressView: UIProgressView) {
        email.text = ""
        password.text = ""
        progressView.progress = 0
    }
    
    ///Clean up text fields for more security.
    func clearFields(_ name: UITextField, _ email: UITextField, _ passwordOne: UITextField, _ passwordTwo: UITextField, _ progressView: UIProgressView) {
        name.text = nil
        email.text = nil
        passwordOne.text = nil
        passwordTwo.text = nil
        progressView.progress = 0
    }
}
