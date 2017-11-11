//
//  TokenCreationViewController.swift
//  game_safe
//
//  Created by Erin Moon on 11/11/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

class TokenCreationCellController: UICollectionViewCell {
    
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenNameLabel: UILabel!
    
}

class TokenCreationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    @IBOutlet weak var TokenViewCollection: UICollectionViewController!
    
    @IBOutlet weak var tokenGold: UIButton!
    @IBOutlet weak var tokenName: UITextField!
    
    var token = [
                "name": "New Token",
                "token": "coin",
                "count": "0"
                ]
    
    let tokens = ["coin", "coin", "coin", "coin", "coin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar()
        self.view.addSubview(navBar)
        
        title = "Create a token"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveToken))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tokens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TokenViewCell", for: indexPath) as? TokenCreationCellController else {
            fatalError("The dequeued cell is not an instance of GameDetailCell.")
        }
        
        cell.tokenImage?.image = UIImage(named: tokens[indexPath.row])
        cell.tokenNameLabel?.text = tokens[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ tableView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        token["token"] = tokens[indexPath.row]
        
        print("Current token is \(token)")
    }

    @objc func saveToken() {
        token["name"] = tokenName?.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
