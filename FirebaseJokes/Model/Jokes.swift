//
//  Jokes.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import Foundation
import Firebase

struct Jokes {
    
    let title: String
    let userId: String
    //Reference к конкретной записи в DB (опционал - создаем локально, а Reference после помещения в базу данный)
    let ref: Firebase.DatabaseReference?
    var liked: Bool = false
    
    //Для создания объекта локально
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    //Для создания объекта из сети
    //DataSnapshot - снимок иерархии DB
    init(snapshot: Firebase.DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        liked = snapshotValue["liked"] as! Bool
        ref = snapshot.ref
    }
    
    //Для заполнение словаря (вызвал функцию и класс)
    func convertToDictionary() -> Any {
        return ["title" : title, "userId" : userId, "liked" : liked]
    }
}
