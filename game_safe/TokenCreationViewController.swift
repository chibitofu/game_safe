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
    
    func resetHighlightTokenCell() {
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = .none
        self.backgroundColor = .none
        self.tag = 3
    }
    
    func highlightTokenCell() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.tag = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetHighlightTokenCell()
    }
}

class TokenCreationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var tokenCollectionView: UICollectionView!
    @IBOutlet weak var tokenName: UITextField!
    @IBAction func changeTokenColor(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        
        var updatedName = (tokenDefault.itemName.components(separatedBy: color))[0]
        
        color = button.title(for: .normal)!
        
        updatedName = "\(updatedName)\(color)"
        tokenDefault.itemName = updatedName
        
        for views in self.view.subviews as [UIView] {
            if let button = views as? UIButton {
                if button.tag == 2 {
                    button.tag = 1
                    resetColorButtonStyle(button: button)
                }
            }
        }
        
        button.tag = 2
        isTappedButtonColorStyle(button: button)
        self.tokenCollectionView.reloadData()
    }

    var gameName = String()
    var color = "gold"
    var tokenDefault = TokenDetailItem(name: "New Token", itemName: "coin_gold", tokenCount: 1, tokenCreatedAt: Date())
    var container: NSPersistentContainer!
    var currentGame = Game()
    var tokenEntity = Token()
    let tokens = ["coin", "moneybag", "bill", "diamond", "heart", "star", "pawn", "pyramid", "ball", "box"]
    var currentlySelectedToken =  UICollectionViewCell()
    var currentlySelectedTokenIndex = IndexPath(row: 0, section: 0)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Did Appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "paperBG")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        tokenCollectionView.backgroundColor = UIColor(patternImage: image)
        
        //Connect to Core Data Enitity
        container = NSPersistentContainer(name: "game_safe")
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("unresolved error \(error)")
            }
        }
        
        //Create navBar
        let navBar = UINavigationBar()
        self.view.addSubview(navBar)
        
        title = "Create a token"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveToken))
        
        //Connect collection view to controller
        tokenCollectionView.dataSource = self
        tokenCollectionView.delegate = self
        self.tokenName.delegate = self
        
        self.view.addSubview(tokenCollectionView)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        loadSavedData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tokens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TokenViewCell", for: indexPath) as? TokenCellController else {
            fatalError("The dequeued cell is not an instance of GameDetailCell.")
        }
        
        for view in self.view.subviews as [UIView] {
            if let button = view as? UIButton {
                if button.tag == 5 {
                    isTappedButtonColorStyle(button: button)
                    button.tag = 2
                }
                button.layer.cornerRadius = 5
            }
        }
        cell.tokenImage?.image = UIImage(named: "\(tokens[indexPath.row])_\(color)")
        cell.tokenNameLabel?.text = tokens[indexPath.row]
        
        if currentlySelectedTokenIndex == indexPath {
            cell.highlightTokenCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TokenCellController {
            cell.highlightTokenCell()
            tokenDefault.itemName = "\(tokens[indexPath.row])_\(color)"
        }
        
        if let deselectCell = collectionView.cellForItem(at: currentlySelectedTokenIndex) as? TokenCellController {
            deselectCell.resetHighlightTokenCell()
        }

        currentlySelectedTokenIndex = indexPath
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tokenCollectionView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        tokenCollectionView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tokenCollectionView.contentInset = contentInset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tokenCollectionView.reloadData()
    }
    
    func isTappedButtonColorStyle(button: UIButton) {
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.backgroundColor = button.backgroundColor?.darker(by: 10)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func resetColorButtonStyle(button: UIButton) {
        button.backgroundColor = button.backgroundColor?.lighter(by: 10)
        button.layer.borderColor = .none
        button.layer.borderWidth = 0
        button.layer.shadowColor = .none
        button.layer.shadowOpacity = 0
        button.layer.shadowRadius = 0
    }

    @objc func saveToken() {
        let currentToken = Token(context: self.container.viewContext)
        
        if !(tokenName.text?.isEmpty)! {
            tokenDefault.name = tokenName.text!
        }

        self.save(currentGame: currentGame, currentToken: currentToken)
        
        self.performSegue(withIdentifier: "unwindToGameDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToGameDetail" {
            let vc = segue.destination as! GameDetailController
            vc.viewDidLoad()
        }
    }
    
    func save(currentGame game: Game, currentToken token: Token) {
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
            currentGame = (try container.viewContext.fetch(request))[0]
        } catch {
            print("Fetch failed")
        }
    }
}
