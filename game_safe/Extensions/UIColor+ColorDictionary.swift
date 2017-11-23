
//
//  colorDic.swift
//  game_safe
//
//  Created by Erin Moon on 11/22/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

//From MrBr on Stackoverflow
extension String {
    
    func emojiToImage() -> UIImage? {
        
        let size = CGSize(width: 75, height: 75)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        UIColor.white.set()
        
        let rect = CGRect(origin: CGPoint(), size: size)
        
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
