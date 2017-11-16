//
//  UIView+XYPosition.swift
//  game_safe
//
//  Created by Erin Moon on 11/16/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

/**
 Extension UIView
 by DaRk-_-D0G
 */

extension UIView {
    
     //Set x Position
    func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }

     //Set y Position
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
     //Set Width
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    //Set Height
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
}
