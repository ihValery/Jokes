//
//  Validate.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit

class HelperСlass {
    
    func displayWarningLabel(warningLabel: UILabel, withText text: String) {
        warningLabel.text = text
        
        //withDuration - продолжительность, delay - задерка, usingSpringWithDamping - интенсивность 0-1
        //options - массив опций - одну опцию можно без скобок
        //animayion - логика анимации и завершающий completion
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) { 
            warningLabel.alpha = 1
        } completion: { complete in
            warningLabel.alpha = 0
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
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
