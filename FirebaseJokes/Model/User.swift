//
//  User.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let name: String
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email ?? "none@example.org"
        self.name = user.displayName ?? "Anonymous"
    }
}
