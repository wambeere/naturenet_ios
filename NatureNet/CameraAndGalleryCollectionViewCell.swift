//
//  CameraAndGalleryCollectionViewCell.swift
//  NatureNet
//
//  Created by James B on 6/10/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class CameraAndGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("successfully awoken")
    }
    
}
