//
//  Cleaner.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit

class Cleaner {
    
    func clearFields(_ emailTF: UITextField, _ passwordTF: UITextField, _ progressView: UIProgressView) {
        emailTF.text = ""
        passwordTF.text = ""
        progressView.progress = 0
    }
}
