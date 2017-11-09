//
//  Game+CoreDataProperties.swift
//  game_safe
//
//  Created by Erin Moon on 11/8/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var name: String
    @NSManaged public var date_created: Date
    @NSManaged public var token: NSArray?

}
