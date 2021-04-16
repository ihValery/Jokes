//
//  Validate.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit

class Validate {
    
    ///When the email is correct and the passwords match, the registration button becomes active.
    func isEnableSignUp(_ email: UITextField, _ passwordOne: UITextField, _ passwordTwo: UITextField, signUp: UIButton) {
        
        guard let email = email.text,
              let passwordOne = passwordOne.text, passwordOne != "",
              let passwordTwo = passwordTwo.text, passwordTwo != "" else { return }
        
        signUp.isEnabled = isValidEmail(email) && ( passwordOne == passwordTwo ) ? true : false
        signUp.alpha = isValidEmail(email) && ( passwordOne == passwordTwo ) ? 1 : 0.75

    }
    
    ///Checks a string for email format
    func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    ///Checks a string for password format. Four levels of password security.
    func isValidPassword(_ textField: UITextField, progressView: UIProgressView) {
        
        let levelTwoBigChar   = NSPredicate(format: "SELF MATCHES %@ ",
                                            "^(?=.*[a-z])(?=.*[A-Z]).{6,}$")
        let levelTwoNumber    = NSPredicate(format: "SELF MATCHES %@ ",
                                            "^(?=.*[a-z])(?=.*[0-9]).{6,}$")
        let levelTwoSpec      = NSPredicate(format: "SELF MATCHES %@ ",
                                            "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
        
        let levelThreeNumber  = NSPredicate(format: "SELF MATCHES %@ ",
                                            "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$")
        let levelThreeSpec    = NSPredicate(format: "SELF MATCHES %@ ",
                                            "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,}$")
        let levelThreeBigChar = NSPredicate(format: "SELF MATCHES %@ ",
                                            "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        let levelFour         = NSPredicate(format: "SELF MATCHES %@ ",
                                            "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{8,}$")
        
        if let pass = textField.text {
            switch pass {
                case _ where levelFour.evaluate(with: pass):
                    progressView.progress = 1
                    progressView.progressTintColor = .green
                    
                case _ where levelThreeBigChar.evaluate(with: pass) || levelThreeNumber.evaluate(with: pass) || levelThreeSpec.evaluate(with: pass):
                    progressView.progress = 0.75
                    progressView.progressTintColor = .systemYellow
                    
                case _ where levelTwoBigChar.evaluate(with: pass) || levelTwoNumber.evaluate(with: pass) || levelTwoSpec.evaluate(with: pass):
                    progressView.progress = 0.5
                    progressView.progressTintColor = .orange
                    
                case _ where pass.count > 4:
                    progressView.progress = 0.25
                    progressView.progressTintColor = .red
                    
                default:
                    progressView.progress = 0
            }
        }
    }
}
