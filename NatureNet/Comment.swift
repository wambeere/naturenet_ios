//
//  Comment.swift
//  NatureNet
//
//  Created by James B on 7/15/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import Foundation

class Comment {
    
    var commenter : String
    var commentText : String
    var timestamp : Int
    
    init(commenter:String, commentText:String, timestamp:Int) {
        self.commenter = commenter
        self.commentText = commentText
        self.timestamp = timestamp
        
    }
}