//
//  WarningLabel.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit

class Warning {
    
    func displayWarningLabel(warningLabel: UILabel, withText text: String) {
        warningLabel.text = text
        
        //withDuration - продолжительность, delay - задерка, usingSpringWithDamping - интенсивность 0-1
        //options - массив опций - одну опцию можно без скобок
        //animayion - логика анимации и завершающий completion
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            warningLabel.alpha = 1
        } completion: { _ in
            warningLabel.alpha = 0
        }
    }
}
