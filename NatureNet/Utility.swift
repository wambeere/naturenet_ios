//
//  Utility.swift
//  NatureNet
//
//  Created by James B on 7/12/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import Foundation

class Utility {
    //Resizing image
    static func resizeImage(image: UIImage) -> NSData {
        let maxSide = CGFloat(1920)
        let originalWidth = image.size.width
        let originalHeight = image.size.height
        
        if(originalWidth > maxSide || originalHeight > maxSide)
        {
            //one of the two has to be 1920, so this is an easy way to give initial values
            var newWidth = maxSide
            var newHeight = maxSide
            
            if(originalWidth >= originalHeight)
            {
                let scaleRatio = originalWidth / maxSide
                newHeight = originalHeight / scaleRatio
            } else {
                let scaleRatio = originalHeight / maxSide
                newWidth = originalWidth / scaleRatio
            }
            
            let rect = CGRectMake(0.0, 0.0, newWidth, newHeight)
            UIGraphicsBeginImageContext(rect.size)
            image.drawInRect(rect)
            let smallerImage = UIGraphicsGetImageFromCurrentImageContext()
            return UIImageJPEGRepresentation(smallerImage, 0.6)! as NSData
            
            
        } else {
            //less compression on the already smaller images
            return UIImageJPEGRepresentation(image, 0.7)! as NSData
        }
    }
}
