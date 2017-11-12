//
//  Game+CoreDataProperties.swift
//  game_safe
//
//  Created by Erin Moon on 11/12/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var date_created: Date
    @NSManaged public var name: String
    @NSManaged public var tokens: NSSet?

}

// MARK: Generated accessors for tokens
extension Game {

    @objc(addTokensObject:)
    @NSManaged public func addToTokens(_ value: Token)

    @objc(removeTokensObject:)
    @NSManaged public func removeFromTokens(_ value: Token)

    @objc(addTokens:)
    @NSManaged public func addToTokens(_ values: NSSet)

    @objc(removeTokens:)
    @NSManaged public func removeFromTokens(_ values: NSSet)

}
