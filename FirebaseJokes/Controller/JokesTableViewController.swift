//
//  JokesTableViewController.swift
//  FirebaseJokes
//
//  Created by Валерий Игнатьев on 15.04.21.
//

import UIKit
import Firebase

class JokesTableViewController: UITableViewController {
    
    private var user: User!
    private var ref: Firebase.DatabaseReference!
    var jokes: [Jokes] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        designNavigationBar()
        
        //Получаем текущего пользователя
        guard let currentUser = Auth.auth().currentUser else { return }
        //Достаем его во "внешний мир" )))
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "user").child(String(user.uid)).child("jokes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] snapshot in
            var _jokes: [Jokes] = []
            for item in snapshot.children {
                let joke = Jokes(snapshot: item as! Firebase.DataSnapshot)
                _jokes.append(joke)
            }
            self?.jokes = _jokes
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jokes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellJokes", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .black
        let joke = jokes[indexPath.row]
        let jokeTitle = joke.title
        cell.textLabel?.text = jokeTitle
        toggleCompletion(cell, isCompleted: joke.liked)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let joke = jokes[indexPath.row]
            joke.ref?.removeValue()
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let joke = jokes[indexPath.row]
        let isCompleted = !joke.liked
        
        toggleCompletion(cell, isCompleted: isCompleted)
        joke.ref?.updateChildValues(["completed" : isCompleted])
    }

    // MARK: - Navigation
    
    
    private func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        
        cell.accessoryType = isCompleted ? .checkmark : .none
    }

    private func designNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 4.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = "Jokes"
    }
    
    
    @IBAction func singOutTap(_ sender: UIBarButtonItem) {
        
        do {
             try Auth.auth().signOut()
         } catch {
             print(error.localizedDescription)
         }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addJokesTap(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a new jokes", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first?.text, textField != "" else { return }
            
            let jokes = Jokes(title: textField, userId: (self?.user.uid)!)
            //joke.title.lowercased() - используется в качестве папки
            let jokeRef = self?.ref.child(jokes.title.lowercased())
            jokeRef?.setValue(jokes.convertToDictionary())
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
