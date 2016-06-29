//
//  NewObsAndDIViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/12/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class NewObsAndDIViewController: UIViewController{
    
    @IBOutlet weak var camButton: UIButton!
    //@IBOutlet var obsAndDIView: UIView!
    @IBOutlet var imageSelectionView: UIView!
    @IBOutlet var viewForPlusDevices: UIView!

    @IBOutlet var designSelectionView: UIView!
    @IBOutlet weak var designIdeaButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    
        
//        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
//        {
//            UIAlertAction in
//            self.openCamera()
//            
//        }
//        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
//        {
//            UIAlertAction in
//            self.openGallary()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
//        {
//            UIAlertAction in
//            
//        }
//        
//        // Add the actions
//        picker?.delegate = self
//        alert.addAction(cameraAction)
//        alert.addAction(gallaryAction)
//        alert.addAction(cancelAction)
//        // Present the controller
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
//        {
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//        else
//        {
//            popover=UIPopoverController(contentViewController: alert)
//            popover!.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
//        }
        //let mapVC = MapViewController()
//        imageSelectionView.frame = CGRectMake(0, self.view.frame.size.height - imageSelectionView.frame.size.height+68, imageSelectionView.frame.size.width, imageSelectionView.frame.size.height)
//        self.view.addSubview(imageSelectionView)
//        self.view.bringSubviewToFront(imageSelectionView)
        
//        let cgVC = CameraAndGalleryViewController()
//        self.addChildViewController(cgVC)
//        cgVC.view.frame = CGRectMake(0, 568, self.view.frame.width, 284)
//        self.view.addSubview(cgVC.view)
//        UIView.animateWithDuration(0.5, animations: {
//            
//            cgVC.view.frame = CGRectMake(0, 284, self.view.frame.width, 284)
//            
//        }) { (isComplete) in
//            
//            cgVC.didMoveToParentViewController(self)
//            
//        }
    
   
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
