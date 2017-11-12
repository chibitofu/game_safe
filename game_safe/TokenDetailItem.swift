//
//  TokenDetail.swift
//  game_safe
//
//  Created by Erin Moon on 11/12/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

class TokenDetailItem: NSObject {
    var name: String
    var itemName: String
    var tokenCount: String
    
    init(name: String, itemName: String, tokenCount: String) {
        self.name = name
        self.itemName = itemName
        self.tokenCount = tokenCount
    }
}
