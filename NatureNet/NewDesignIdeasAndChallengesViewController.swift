//
//  NewDesignIdeasAndChallengesViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/19/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Firebase

class NewDesignIdeasAndChallengesViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate{
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var design: String = ""
    
    var isDesignIdea: Bool = false

    @IBOutlet weak var photoAndGalleryView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ideaOrChallengeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(isDesignIdea == true)
        {
            self.navigationItem.title="Design Idea"
            //isDesignIdea = false
            design = "Idea"
        }
        else
        {
            self.navigationItem.title="Design Challenge"
            design = "Challenge"
        }
        
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "double_down.png"), style: .Plain, target: self, action: #selector(NewDesignIdeasAndChallengesViewController.dismissVC))
        navigationItem.leftBarButtonItem = barButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Send", style: .Plain, target: self, action: #selector(NewDesignIdeasAndChallengesViewController.postDesign))
        rightBarButtonItem.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        picker!.delegate=self
        textView.delegate = self
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewDesignIdeasAndChallengesViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewDesignIdeasAndChallengesViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
//        if(text.isEqualToString:"\n"]) {
//            [textView resignFirstResponder];
//            return NO;
//        }
        
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            //print(photoAndGalleryView.frame.origin.y)
//            self.photoAndGalleryView.frame.origin.y -= keyboardSize.height
//            //print(photoAndGalleryView.frame.origin.y)
//            self.view.bringSubviewToFront(photoAndGalleryView)
//        }
//        
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            self.photoAndGalleryView.frame.origin.y += keyboardSize.height
//            print(photoAndGalleryView.frame.origin.y)
//        }
//    }
    
   
    
   
    
    func dismissVC(){
        
        //self.navigationController!.dismissViewControllerAnimated(true, completion: {})
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        //self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        //print("abhi")
        
    }
    func postDesign()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var userID: String = ""
        if(userDefaults.objectForKey("userID") != nil)
        {
            userID = (userDefaults.objectForKey("userID") as? String)!
        }
        let email = userDefaults.objectForKey("email") as? String
        let password = userDefaults.objectForKey("password") as? String
        
        print(userID)
        let refUser = Firebase(url: FIREBASE_URL)
        refUser.authUser(email, password: password,
                         withCompletionBlock: { error, authData in
                            if error != nil {
                                
                                print("\(error)")
                                let alert = UIAlertController(title: "Alert", message:error.localizedDescription.debugDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                let showMenuAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                                    UIAlertAction in
                                    //print("OK Pressed")
                                    //self.dismissVC()
                                    
                                    let signInSignUpVC=SignInSignUpViewController()
                                    let signInSignUpNavVC = UINavigationController()
                                    signInSignUpVC.pageTitle="Sign In"
                                    signInSignUpNavVC.viewControllers = [signInSignUpVC]
                                    self.presentViewController(signInSignUpNavVC, animated: true, completion: nil)
                                }
                                
                                // Add the actions
                                alert.addAction(showMenuAction)
                                
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                
                            }
                            else
                            {
                                let ref = Firebase(url: POST_IDEAS_URL)
                                print(ref.childByAutoId())
                                let autoID = ref.childByAutoId()
                                //let id = autoID as String
                                print(autoID.key)
                                let designData = ["id": autoID.key as AnyObject,"content": self.textView.text as AnyObject,"group": self.design as AnyObject, "status": "Doing" ,"submitter": userID as AnyObject,"created_at": FirebaseServerValue.timestamp(),"updated_at": FirebaseServerValue.timestamp()]
                                autoID.setValue(designData)
                            }
                            
                            })
        
        //let usersPrivateReftoid = usersRef.childByAppendingPath("private")
        //let usersPrivate = ["email": self.joinEmail.text as! AnyObject]
        //usersRef.setValue(usersPub)
        //OBSERVATION_IMAGE_UPLOAD_URL = ""
        
    

    }

    @IBAction func openCamera(sender: UIButton) {
        
        self.openCam()
        
    }

    @IBAction func openGallery(sender: UIButton) {
        
        self.openGlry()
        
    }
    
    func openCam()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGlry()
        }
    }
    func openGlry()
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
        print("****##",info[UIImagePickerControllerOriginalImage])
        
        ideaOrChallengeImageView.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
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
