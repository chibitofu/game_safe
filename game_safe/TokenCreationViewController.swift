//
//  TokenCreationViewController.swift
//  game_safe
//
//  Created by Erin Moon on 11/11/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit
import CoreData

class TokenCellController: UICollectionViewCell {
    
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
}

//class TokenCreationCollectionView: UICollectionView {
//    func reloadCollectionView() {
//        self.reloadData()
//    }
//}

class TokenCreationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let layout = UICollectionViewFlowLayout()
    
//    @IBOutlet weak var TokenViewCollection: UICollectionView!
    @IBOutlet weak var tokenName: UITextField!
    @IBAction func changeTokenColor(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        
        buttonClicked(sender: button)
        color = button.title(for: .normal)!
        
        for views in self.view.subviews as [UIView] {
            if let buttonTag = views as? UIButton {
                if (buttonTag.viewWithTag(2) != nil) {
                    buttonTag.backgroundColor = buttonTag.backgroundColor?.lighter(by: 30)
                    buttonTag.tag = 1
                }
            }
        }
        
        button.tag = 2
        button.backgroundColor = button.backgroundColor?.darker(by: 30)
        tokenCollectionView.reloadData()
    }
    
    func tokenButtonHighlight(sender: Any, indexPath: IndexPath) {
        let cell =  collectionView(tokenCollectionView, cellForItemAt: indexPath) as UICollectionViewCell
        cell.layer.borderWidth = 4.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.backgroundColor = UIColor.blue

        tokenCollectionView.reloadItems(at: [indexPath])
        
        print("tapped")
        print(cell.layer.borderWidth)
    }
    
    @IBOutlet weak var tokenCollectionView: UICollectionView!
    
    var gameName = String()
    var color = "gold"
    var tokenDefault = TokenDetailItem(name: "New Token", itemName: "coin_gold", tokenCount: 1, tokenCreatedAt: Date())
    var container: NSPersistentContainer!
    var currentGame = [Game]()
    var tokenEntity = Token()
    let tokens = ["coin", "moneybag", "bill", "diamond", "heart", "star", "pawn", "pyramid", "ball", "box"]
    var isHighLighted:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tokenCollectionView.dataSource = self
        tokenCollectionView.delegate = self
        
        self.view.addSubview(tokenCollectionView)
 
        container = NSPersistentContainer(name: "game_safe")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("unresolved error \(error)")
            }
            
        }
        
        let navBar = UINavigationBar()
        self.view.addSubview(navBar)
        
        title = "Create a token"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveToken))
        
        loadSavedData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tokens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TokenViewCell", for: indexPath) as? TokenCellController else {
            fatalError("The dequeued cell is not an instance of GameDetailCell.")
        }
 
        cell.tokenImage?.image = UIImage(named: "\(tokens[indexPath.row])_\(color)")
        cell.tokenNameLabel?.text = tokens[indexPath.row]
 
        return cell
    }
    
    func collectionView(_ tableView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tokenDefault.itemName = "\(tokens[indexPath.row])_\(color)"
        
        
        for cell in tokenCollectionView.visibleCells {
            if cell.tag == 2 {
                cell.layer.borderWidth = 0
                cell.layer.borderColor = .none
                cell.backgroundColor = .none
                cell.tag = 1
            }
        }
        
        if let selectedCell = tokenCollectionView.cellForItem(at: indexPath) {
            if selectedCell.tag == 1 {
                selectedCell.layer.borderWidth = 4
                selectedCell.layer.borderColor = UIColor.red.cgColor
                selectedCell.backgroundColor = UIColor.blue
                selectedCell.tag = 2
            }

        }

    }

    @objc func saveToken() {
        let currentToken = Token(context: self.container.viewContext)
        
        if !(tokenName.text?.isEmpty)! {
            tokenDefault.name = tokenName.text!
        }

        self.save(currentGame: currentGame[0], currentToken: currentToken, gameName: gameName)
        
        self.performSegue(withIdentifier: "unwindToGameDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToGameDetail" {
            let vc = segue.destination as! GameDetailController
            vc.viewDidLoad()
        }
    }
    
    func save(currentGame game: Game, currentToken token: Token, gameName: String) {
        token.name = tokenDefault.name
        token.itemName = tokenDefault.itemName
        token.tokenCount = tokenDefault.tokenCount
        token.createdAt = Date()
        
        game.addToTokens(token)
        
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
        let filter = NSPredicate(format: "name = %@", gameName)
        request.predicate = filter
        
        do {
            currentGame = try container.viewContext.fetch(request)
            print("Got \(currentGame[0].name.description)")
        } catch {
            print("Fetch failed")
        }
    }
    
    func buttonClicked(sender: UIButton) {
        DispatchQueue.main.async() {
            if self.isHighLighted == false {
                sender.isHighlighted = true
                self.isHighLighted = true
            } else {
                sender.isHighlighted = false
                self.isHighLighted = false
            }
        }
    }

}
