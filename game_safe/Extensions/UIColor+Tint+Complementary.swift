//
//  UIColor+Tint.swift
//  game_safe
//
//  Created by Erin Moon on 11/14/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else {
            return nil
        }
    }
}

//Code from github.com/klein-artur/025a0fa4f167a648d9ea
// get a complementary color to this color:
func getComplementaryForColor(color: UIColor) -> UIColor {
    
    let ciColor = CIColor(color: color)
    
    // get the current values and make the difference from white:
    let compRed: CGFloat = 1.0 - ciColor.red
    let compGreen: CGFloat = 1.0 - ciColor.green
    let compBlue: CGFloat = 1.0 - ciColor.blue
    
    return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
}
