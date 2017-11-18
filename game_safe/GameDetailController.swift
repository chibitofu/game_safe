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
        super.viewDidAppear(true)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "paperBG")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        tokens.removeAll(keepingCapacity: true)
        
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
            self.changeCounter(increaseCounter: isTrue, cell: cell, index: indexPath.row, sender: self)
        }
        
        let currentToken = tokens[indexPath.row]
        
        let image2 = UIImage(named: currentToken.itemName)
        var cellImage = cell.tokenImage
        
        cellImage = UIImageView(image: image2?.addImagePadding(x: 5, y: 5))
        cell.tokenNameLabel?.text = currentToken.name
        cell.tokenCountLabel?.text = String(currentToken.tokenCount)
        
        cellImage?.layer.cornerRadius = 10
        cellImage?.backgroundColor = UIColor.white
        cellImage?.setX(x: 10)
        cellImage?.setY(y: 10)
        cell.addSubview(cellImage!)
        return cell
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let token = tokens[indexPath.row].name
            
            self.tokens.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteData(deleteToken: token)
        }
    }

    func changeCounter(increaseCounter: Bool, cell: GameDetailCell, index: Int, sender: Any) {
        let request = Token.createFetchRequest()
        let filter = NSPredicate(format: "name = %@", "\(tokens[index].name)")
        request.predicate = filter
        
        do {
            let currentToken = try container.viewContext.fetch(request)
            if increaseCounter {
                currentToken[0].tokenCount += 1
            } else {
                currentToken[0].tokenCount -= 1
            }
            
            cell.tokenCountLabel?.text = String(currentToken[0].tokenCount)
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
    
    func deleteData(deleteToken: String) {
        let request = Token.createFetchRequest()
        let filter = NSPredicate(format: "name = %@", "\(deleteToken)")
        
        request.predicate = filter

        do {
            let fetchData = try container.viewContext.fetch(request)

            for object in fetchData {
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
    
    func loadSavedData() {
        let request = Game.createFetchRequest()
        let filter = NSPredicate(format: "name = %@", "\(gameDetail.name.description)")

        request.predicate = filter

        do {
            let fetchData = try container.viewContext.fetch(request)
            let tokenData = fetchData[0].tokens
            
            if !(tokenData != nil) {
                return
            } else {
                for token in tokenData! {
                    let name = token.name
                    let itemName = token.itemName
                    let tokenCount = token.tokenCount
                    let tokenCreatedAt = token.createdAt
                    let newToken = TokenDetailItem(name: name, itemName: itemName, tokenCount: tokenCount, tokenCreatedAt: tokenCreatedAt)
                    tokens.append(newToken)
                    tokens = tokens.sorted(by: {$0.tokenCreatedAt > $1.tokenCreatedAt})
                }
            }
        } catch {
            print("Fetch failed")
        }
    }
}
