//
//  DetailedObservationViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/20/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit


class DetailedObservationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var observationImageView: UIImageView!
    @IBOutlet weak var observationTextLabel: UILabel!
    @IBOutlet weak var observerAffiliationLabel: UILabel!
    @IBOutlet weak var observerDisplayNameLabel: UILabel!
    @IBOutlet weak var observerAvatarImageView: UIImageView!
    var observerImageUrl : String = ""
    var observerDisplayName : String = ""
    var observerAffiliation : String = ""
    var observationImageUrl : String = ""
    var observationText : String = ""
    var isfromMapView : Bool = false
    
    var observationsIdsfromExploreView : NSMutableArray = []
    var commentsDictfromExploreView : NSDictionary = [:]
    
    @IBOutlet weak var commentTF: UITextField!
    var commentsArray : NSMutableArray = []
    var commentersArray : NSMutableArray = []

    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="Native or Not?"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        print(observerImageUrl)
        print(observerDisplayName)
        print(observerAffiliation)
        print(observationImageUrl)
        
        print(commentsDictfromExploreView)
        
        
        
        
        if((observerImageUrl) != "")
        {
            if let observerAvatarUrl  = NSURL(string: observerImageUrl ),
                observerAvatarData = NSData(contentsOfURL: observerAvatarUrl)
            {
                observerAvatarImageView.image = UIImage(data: observerAvatarData)
            }
        }
        if((observationImageUrl) != "")
        {
            if let obsImageUrl  = NSURL(string: observationImageUrl ),
                obsImgData = NSData(contentsOfURL: obsImageUrl)
            {
                observationImageView.image = UIImage(data: obsImgData)
            }
        }
        
        observerDisplayNameLabel.text = observerDisplayName
        observerAffiliationLabel.text = observerAffiliation
        observationTextLabel.text = observationText
        
        
        
        
        observerAvatarImageView.layer.cornerRadius = 30.0
        observerAvatarImageView.clipsToBounds = true
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.separatorColor = UIColor.clearColor()
        
        commentsTableView.registerNib(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        for j in 0 ..< commentsDictfromExploreView.count
        {
            let comments = commentsDictfromExploreView.allValues[j] as! NSDictionary
            print(comments)
            commentsArray.addObject(comments.objectForKey("comment")!)
            commentersArray.addObject(comments.objectForKey("commenter")!)
        }
        commentTF.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedObservationViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)



    }
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        //setViewToMoveUp(false,tempTF: textField)
        return true;
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
    {
        //setViewToMoveUp(true,tempTF: textField)
        return true
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
//    func setViewToMoveUp(moveUp: Bool, tempTF: UITextField!)
//    {
//        
//        
//            UIView.animateWithDuration(0.3, animations: {
//                
//                var tfRect: CGRect!
//                tfRect=tempTF.frame
//                
//                if(moveUp)
//                {
//                    
//                }
//                else
//                {
//                    
//                }
//                
//                
//                }, completion: { finished in
//                    
//            })
//            
//        
//    }
//    override func viewWillAppear(animated: Bool) {
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInSignUpViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInSignUpViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
//        
//    }
//    override func viewWillDisappear(animated: Bool) {
//        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
//        
//        
//    }


    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentsTableViewCell
        
        cell.commentLabel.text = commentsArray[indexPath.row] as? String
        
        
                let url = NSURL(string: USERS_URL+"\(self.commentersArray[indexPath.row]).json")
                var userData:NSData? = nil
                do {
                    userData = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
                    print(userData)
                }
                catch {
                    print("Handle \(error) here")
                }
                
                if let data = userData {
                    // Convert data to JSON here
                    do{
                        let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
                        print(json)
                        
                        //print(observerData.objectForKey("affiliation"))
                        //print(observerData.objectForKey("display_name"))
                        //print(observerData)
                        if((json.objectForKey("affiliation")) != nil)
                        {
                            let observerAffiliationString = json.objectForKey("affiliation") as! String
                           cell.commentorDateLabel.text = observerAffiliationString
                            //observerAffiliationsArray.addObject(observerAffiliationString)
                            print(observerAffiliationString)
                        }
                        else
                        {
                            cell.commentorDateLabel.text = ""
                        }
                        
                        if((json.objectForKey("display_name")) != nil)
                        {
                            let observerDisplayNameString = json.objectForKey("display_name") as! String
                            cell.commentorNameLabel.text = observerDisplayNameString
                            //observerNamesArray.addObject(observerDisplayNameString)
                        }
                        else
                        {
                            cell.commentorNameLabel.text = ""
                        }
                        
                        //print(observerAffiliation)
                        //print(observerDisplayName)
                        if((json.objectForKey("avatar")) != nil)
                        {
                            let observerAvatar = json.objectForKey("avatar")
                            if let observerAvatarUrl  = NSURL(string: observerAvatar as! String),
                                observerAvatarData = NSData(contentsOfURL: observerAvatarUrl)
                            {
                                cell.commentorAvatarImageView.image = UIImage(data: observerAvatarData)
                                //observerAvatarsArray.addObject(observerAvatar!)
                                //self.observerAvatarUrlString = observerAvatar as! String
                            }
                        }
                        else
                        {
                            cell.commentorAvatarImageView.image = UIImage(named:"user.png")
                            //observerAvatarsArray.addObject(NSBundle.mainBundle().URLForResource("user", withExtension: "png")!)
                            
                        }
                        
                        
                        
                    }catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                        let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
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
