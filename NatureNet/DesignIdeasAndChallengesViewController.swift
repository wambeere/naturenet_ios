//
//  DesignIdeasAndChallengesViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/19/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class DesignIdeasAndChallengesViewController: UIViewController {
    
    

    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func disignIdeasButtonClicked(sender: UIButton) {
        
        let newDIandDCVC = NewDesignIdeasAndChallengesViewController()
        let navVC = UINavigationController()
        newDIandDCVC.isDesignIdea = true
        navVC.viewControllers = [newDIandDCVC]
        self.presentViewController(navVC, animated: true, completion: nil)
        
    }
    @IBAction func designChallengesButtonClicked(sender: UIButton) {
        
        let newDIandDCVC = NewDesignIdeasAndChallengesViewController()
        let navVC = UINavigationController()
        newDIandDCVC.isDesignIdea = false
        navVC.viewControllers = [newDIandDCVC]
        self.presentViewController(navVC, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
