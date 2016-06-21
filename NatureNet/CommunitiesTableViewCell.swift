//
//  CommunitiesTableViewCell.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 6/19/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class CommunitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var communitiesPersonImageView: UIImageView!
    @IBOutlet weak var communitiesPersonNameLabel: UILabel!
    
    @IBOutlet weak var communitiesPersonAffiliationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
