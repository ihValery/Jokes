//
//  LoginScreenViewController.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit

class LoginScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func singInTap() {
        
        performSegue(withIdentifier: "toJokes", sender: nil)
    }
}
