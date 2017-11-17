//
//  ViewController.swift
//  game_safe
//
//  Created by Erin Moon on 11/5/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var container: NSPersistentContainer!
    var gameCollection = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Game Safe"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCollection))
        
        container = NSPersistentContainer(name: "game_safe")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("unresolved error \(error)")
            }
        }
        
        loadSavedData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        
        let game = gameCollection[indexPath.row]
        cell.textLabel!.text = game.name.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        self.performSegue(withIdentifier: "GameDetailViewSegue", sender: self)
    }
    
    @objc func addCollection() {
        let ac = UIAlertController(title: "Create new safe", message: "Enter name of the safe", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = ac.textFields?.first,
                let nameToSave = textField.text else { return }
            let currentGame = Game(context: self.container.viewContext)
            
            self.save(addGame: currentGame, gameName: nameToSave)
            self.tableView.reloadData()
            
            self.performSegue(withIdentifier: "GameDetailViewSegue", sender: self)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        ac.addTextField()
        ac.addAction(save)
        ac.addAction(cancel)
        ac.textFields?.first?.autocapitalizationType = .sentences
        
        present(ac, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameDetailViewSegue" {
            let vc = segue.destination as! GameDetailController
            
            if ((self.tableView.indexPathForSelectedRow) != nil) {
                vc.gameDetail = gameCollection[self.tableView.indexPathForSelectedRow!.row]
            } else {
                vc.gameDetail = gameCollection[0]
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let gameName = gameCollection[indexPath.row].name
            
            self.gameCollection.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteData(deleteGame: gameName)
        }
    }
    
    func save(addGame game: Game, gameName: String) {
        let date = Date()
        
        game.name = gameName
        game.createdAt = date
        
        gameCollection.insert(game, at: 0)
        
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = Game.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            gameCollection = try container.viewContext.fetch(request)
            print("Got \(gameCollection.count) commits.")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func deleteData(deleteGame: String) {
        let request = Game.createFetchRequest()
        let filter = NSPredicate(format: "name = %@", "\(deleteGame)")
        
        request.predicate = filter
        
        do {
            let fetchData = try container.viewContext.fetch(request)
            
            for object in fetchData {
                print(object.name)
                container.viewContext.delete(object)
            }
        } catch {
            print("Fetch failed")
        }
        
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}

