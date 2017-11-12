//
//  GameDetailController.swift
//  game_safe
//
//  Created by Erin Moon on 11/9/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit
import CoreData

class GameDetailCell: UITableViewCell {
    var tapped: ((GameDetailCell, Bool) -> Void)?
    
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    @IBOutlet weak var tokenCountLabel: UILabel!
    
    @IBAction func countIncrease(_ sender: Any) {
        tapped?(self, true)
    }
    
    @IBAction func countDecrease(_ sender: Any) {
        tapped?(self, false)
    }

}

class GameDetailController: UITableViewController {
    
    @IBAction func unwindToGameDetail(segue: UIStoryboardSegue) {}
    
    var container: NSPersistentContainer!
    var gameDetail = Game()
    var tokens = [TokenDetailItem]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar()
        self.view.addSubview(navBar)
        
        title = "\(gameDetail.name.description)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tokenCreate))
        
        container = NSPersistentContainer(name: "game_safe")
        
        container.loadPersistentStores() { (description, error) in
            
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
        return tokens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TokenCell", for: indexPath) as? GameDetailCell else {
            fatalError("The dequeued cell is not an instance of GameDetailCell.")
        }
        
        cell.tapped = { [unowned self] (selectedCell, isTrue) -> Void in
            self.changeCounter(increaseCounter: isTrue)
        }
        
        let currentToken = tokens[indexPath.row]
        
        cell.tokenImage?.image = UIImage(named: currentToken.itemName)
        cell.tokenNameLabel?.text = currentToken.name
        cell.tokenCountLabel?.text = currentToken.tokenCount
        
        return cell
    }
    
    @objc func reloadTableview() {
        tableView.reloadData()
    }
    
    @objc func tokenCreate() {
         self.performSegue(withIdentifier: "TokenCreationViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TokenCreationViewSegue" {
            let vc = segue.destination as! TokenCreationViewController
            vc.gameName = gameDetail.name
        }
    }

    func changeCounter(increaseCounter: Bool) {
        if increaseCounter {
            print("Increase Counter")
        } else {
            print("Decrease Counter")
        }

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
        let sort = NSSortDescriptor(key: "date_created", ascending: false)
        let filter = NSPredicate(format: "name = %@", "\(gameDetail.name.description)")
        
        request.sortDescriptors = [sort]
        request.predicate = filter

        do {
            
            let fetchData = try container.viewContext.fetch(request)
            let tokenData = fetchData[0].tokens
            
            if !(tokenData != nil) {
                return
            } else  {
                for token in tokenData! {
                    let name = token.name
                    let itemName = token.itemName
                    let tokenCount = token.tokenCount
                    let newToken = TokenDetailItem(name: name, itemName: itemName, tokenCount: tokenCount)
                    tokens.append(newToken)
                }
            }
            
        } catch {
            print("Fetch failed")
        }
    }
    
}
