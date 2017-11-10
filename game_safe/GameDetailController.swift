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
    
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var tokenCount: UILabel!
    
    @IBAction func countIncrease(_ sender: Any) {
        //increase count function
    }
    
    @IBAction func countDecrease(_ sender: Any) {
        //decrease count function
    }
}

class GameDetailController: UITableViewController, UITextFieldDelegate {
    
    var container: NSPersistentContainer!
    var gameDetail = Game()
    var tokens = [ String: [String: String] ]()
    
//    struct gameInfo {
//        var name: String
//        var date: Date
//        var token: [String: Int]
//
//        init(name: String, date: Date, token: [String: Int]) {
//            self.name = name
//            self.date = date
//            self.token = token
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokens = ["Coin": ["Count": "25"]]
        
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
        
        cell.tokenImage?.image = UIImage(named: "coin")
        cell.tokenName?.text = "coin"
        cell.tokenCount?.text = "25"
        
        return cell
    }
    
    @objc func tokenCreate() {
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
