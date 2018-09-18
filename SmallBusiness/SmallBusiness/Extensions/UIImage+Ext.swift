//
//  UIImage+Ext.swift
//  O-Mart
//
//  Created by Ô Chợ Việt on 10/17/17.
//  Copyright © 2017 Ô Chợ Việt. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.rgba(r, g, b, 1)
    }
    
    class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIImage {
    public var memsize: Double {
        guard let imageData = UIImageJPEGRepresentation(self, 1) else { return 0 }
        let size: Double = Double(imageData.count) / 1000.0
        return size
    }
    
    var dataValue: Data? {
        return UIImageJPEGRepresentation(self, 1)
    }
    
    func toData(stride: CGFloat = 1) -> Data? {
        return UIImageJPEGRepresentation(self, stride)
    }
    
    func createRoundedImage() -> UIImage {
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        imageLayer.contents = self.cgImage
        
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = self.size.width / 2
        
        UIGraphicsBeginImageContext(self.size)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        // Create a 1 by 1 pixel context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect) // Fill it with your color
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
