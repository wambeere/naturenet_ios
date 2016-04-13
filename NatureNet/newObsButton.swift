//
//  newObsButton.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/13/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class newObsButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // The resetMe function sets up the values for this button. It is
        // called here when the button first appears and is also called
        // from the main ViewController when all the buttons have been tapped
        // and the app is reset.
       self.setBackgroundImage(UIImage(named: "add observation.png"), forState: UIControlState.Normal)
        //self.addTarget(self, action: #selector(newObsButton.openCamera), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
//    func openCamera()
//    {
//        //if let rv = UIApplication.sharedApplication().keyWindow{
//            
//            
//        //}
//    }
}
