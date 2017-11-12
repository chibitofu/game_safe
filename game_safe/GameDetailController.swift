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
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var tokenCount: UILabel!
    
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
    var tokens = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokens = [
            [
            "name": "coin",
            "token": "coin_gold",
            "count": "25"
            ]
        ]
        
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
        
        cell.tokenImage?.image = UIImage(named: currentToken["token"]!)
        cell.tokenName?.text = currentToken["name"]
        cell.tokenCount?.text = currentToken["count"]
        
        return cell
    }
    
    @objc func tokenCreate() {
         self.performSegue(withIdentifier: "TokenCreationViewSegue", sender: self)
        //create token here
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
        request.sortDescriptors = [sort]
        
        do {
            let fetchData = try container.viewContext.fetch(request)
            print("Got \(gameDetail) commits.")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
