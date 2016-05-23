//
//  CameraAndGalleryViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/12/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class CameraAndGalleryViewController: UIViewController ,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        picker!.delegate=self
    }
    
        
    @IBAction func cameraButtonClicked(sender: UIButton) {
        
        self.openCamera()
        
    }
    @IBAction func galleryButtonClicked(sender: UIButton) {
    
        self.openGallary()
    
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        //imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        print(info[UIImagePickerControllerOriginalImage])
        
        let newObsVC = NewObsViewController()
        newObsVC.obsImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        let newObsNavVC = UINavigationController()
        newObsNavVC.viewControllers = [newObsVC]
        self.presentViewController(newObsNavVC, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
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
