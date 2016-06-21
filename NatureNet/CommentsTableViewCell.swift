//
//  CommentsTableViewCell.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/7/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentorNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentorDateLabel: UILabel!
    @IBOutlet weak var commentorAvatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
