//
//  Token+CoreDataProperties.swift
//  game_safe
//
//  Created by Erin Moon on 11/12/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//
//

import Foundation
import CoreData


extension Token {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Token> {
        return NSFetchRequest<Token>(entityName: "Token")
    }

    @NSManaged public var name: String
    @NSManaged public var count: String
    @NSManaged public var type: String
    @NSManaged public var game: Game

}
