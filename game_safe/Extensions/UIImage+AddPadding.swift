//
//  UIImage+AddPadding.swift
//  game_safe
//
//  Created by Erin Moon on 11/16/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

extension UIImage {
    
    func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = 75 + x
        let height: CGFloat = 75 + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - self.size.width) / 2, y: (height - self.size.height) / 2)
        self.draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
}
