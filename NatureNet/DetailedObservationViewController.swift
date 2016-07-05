//
//  DetailedObservationViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/20/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class DetailedObservationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var observationImageView: UIImageView!
    @IBOutlet weak var observationPostedDateLabel: UILabel!
    var obsupdateddate: NSNumber = 0
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
    var isfromDesignIdeasView : Bool = false
    var designID: String = ""
    var isObservationLiked : Bool = false
    
    
    var observationId : String = ""
    var commentsDictfromExploreView : NSDictionary = [:]
    var observationCommentsArrayfromExploreView : NSArray = []
    
    var pageTitle: String = ""
    
    var commentContext : String = ""
    
    var likesCount: Int = 0
    var dislikesCount: Int = 0
    
    @IBOutlet weak var likeButtonForDesign: UIButton!
    
    @IBOutlet weak var dislikeButtonForDesign: UIButton!
    
    @IBOutlet weak var likedislikeView: UIView!
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var dislikesCountLabel: UILabel!
    
    var likesCountFromDesignIdeasView : Int = 0
    var dislikesCountFromDesignIdeasView : Int = 0
    @IBOutlet weak var likeButtonBesidesCommentBox: UIButton!
    
    var isUserLiked : Bool = false
    var isUserDisLiked : Bool = false
    
    @IBOutlet weak var commentTF: UITextField!
    
    var detailed_commentsDictArray : NSMutableArray = []
    var detailed_commentsCount: Int = 0
    var commentsArray : NSMutableArray = []
    var commentersArray : NSMutableArray = []

    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(observationId)
        self.navigationItem.title=pageTitle
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        print(observationId)
        print(observerImageUrl)
        print(observerDisplayName)
        print(observerAffiliation)
        
        
        
        print(observationImageUrl)
        
        print(commentsDictfromExploreView)
        
        print(observationCommentsArrayfromExploreView)
        
        likedislikeView.hidden = true
        
        observationPostedDateLabel.text = ""
        
        if(obsupdateddate != 0)
        {
            let date = NSDate(timeIntervalSince1970:Double(obsupdateddate)/1000)
            print(date)
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale.currentLocale()
            formatter.timeZone = NSTimeZone.localTimeZone()
            //formatter.dateFormat = "EEEE, MMMM dd yyyy"
            formatter.dateStyle = NSDateFormatterStyle.FullStyle
            formatter.timeStyle = .ShortStyle
            
            let dateString = formatter.stringFromDate(date)
            
            print(dateString)
            
            observationPostedDateLabel.text = dateString

        }
        else
        {
            observationPostedDateLabel.text = ""
        }
        
        
        if(isfromDesignIdeasView)
        {
            likedislikeView.hidden = false
            likeButtonBesidesCommentBox.hidden = true
            
            likesCountLabel.text = "\(likesCountFromDesignIdeasView)"
            dislikesCountLabel.text = "\(dislikesCountFromDesignIdeasView)"
            
            commentContext = "ideas"
            
            getUpdatedlikestoDesignIdeas()
            //observationImageView.hidden = true
            
//            likedislikeView.frame = CGRectMake(likedislikeView.frame.origin.x, observationTextLabel.frame.origin.y+observationTextLabel.frame.size.height+8, likedislikeView.frame.size.width, likedislikeView.frame.size.height)
//            commentsTableView.frame = CGRectMake(commentsTableView.frame.origin.x, likedislikeView.frame.origin.y+likedislikeView.frame.size.height+8, commentsTableView.frame.size.width, commentsTableView.frame.size.height)
//            
//            print(likedislikeView.frame)
        }
        
        else
        {
            commentContext = "observations"
            getLikesToObservations()
        }
        
        let observerAvatarUrl  = NSURL(string: observerImageUrl )

        observerAvatarImageView?.kf_setImageWithURL(observerAvatarUrl!, placeholderImage: UIImage(named: "user.png"))
        
        print(observationImageUrl)
        //if((observationImageUrl) != "")
        //{
            let obsImageUrl  = NSURL(string: observationImageUrl )
            observationImageView.kf_setImageWithURL(obsImageUrl! , placeholderImage: UIImage(named: "default-no-image.png"))
        //}
//        else
//        {
//            print("in")
//            observationImageView.removeFromSuperview()
//            view.updateConstraints()
//        }
        
        observerDisplayNameLabel.text = observerDisplayName
        
        
//        let sitesRootRef = FIRDatabase.database().referenceWithPath("sites/"+observerAffiliation)
//        //Firebase(url:FIREBASE_URL + "sites/"+aff!)
//        sitesRootRef.observeEventType(.Value, withBlock: { snapshot in
//            
//            
//            print(sitesRootRef)
//            print(snapshot.value)
//            
//            if !(snapshot.value is NSNull)
//            {
//                
//                
//                print(snapshot.value!.objectForKey("name"))
//                if(snapshot.value!.objectForKey("name") != nil)
//                {
//                    self.observerAffiliationLabel.text = snapshot.value!.objectForKey("name") as? String
//                    //self.observerAffiliationsArray.addObject((snapshot.value!.objectForKey("name") as? String)!)
//                }
//                
//                
//                
//            }
//            
//            }, withCancelBlock: { error in
//                print(error.description)
//        })

        
        observerAffiliationLabel.text = observerAffiliation
        observationTextLabel.text = observationText
        //observationTextLabel.sizeToFit()
        
        
        
        
        observerAvatarImageView.layer.cornerRadius = 30.0
        observerAvatarImageView.clipsToBounds = true
        
        
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.separatorColor = UIColor.clearColor()
        
        commentsTableView.registerNib(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        commentTF.delegate = self
        
        getCommentsDetails(observationCommentsArrayfromExploreView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedObservationViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailedObservationViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        

        

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
    
    func getLikesToObservations()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var userID = String()
        if(userDefaults.objectForKey("userID") != nil)
        {
            userID = (userDefaults.objectForKey("userID") as? String)!
        }
        if(userID != "" || self.observationId != "")
        {
            let observationRootRef = FIRDatabase.database().referenceWithPath("observations/" + String(self.observationId)) //Firebase(url:POST_IDEAS_URL + observationId)
            observationRootRef.observeEventType(.Value, withBlock: { snapshot in
                
                print(observationRootRef)
                print(snapshot.value)
                
                if !(snapshot.value is NSNull)
                {
                    
                    if(snapshot.value!.objectForKey("likes") != nil)
                    {
                        let likesDictionary = snapshot.value!.objectForKey("likes") as! NSDictionary
                        print(likesDictionary.allValues)
                        
                        let likesArray = likesDictionary.allValues as NSArray
                        print(likesArray)
                        
                        let userKeys = likesDictionary.allKeys as NSArray
                        print(userKeys)
                        
                        //let userDefaults = NSUserDefaults.standardUserDefaults()
                        //var userID = String()
                        
                        if((userDefaults.stringForKey("isSignedIn")) == "true")
                        {
                            if(userKeys.containsObject(userID))
                            {
                                if(likesDictionary.objectForKey(userID) as! NSObject == 1)
                                {
                                    self.isObservationLiked = true
                                    
                                    self.likeButtonBesidesCommentBox.selected = true
                                    self.likeButtonBesidesCommentBox.userInteractionEnabled = false
                                    
                                }
                                else
                                {
                                    self.isObservationLiked = false
                                    
                                    self.likeButtonBesidesCommentBox.selected = false
                                    self.likeButtonBesidesCommentBox.userInteractionEnabled = true
                                }
                            }
                            else
                            {
                                self.isObservationLiked = false
                                
                                self.likeButtonBesidesCommentBox.selected = false
                                self.likeButtonBesidesCommentBox.userInteractionEnabled = true
                                
                            }
                            
                        }
                        else{
                            
                            self.isObservationLiked = false
                            
                            self.likeButtonBesidesCommentBox.selected = false
                            self.likeButtonBesidesCommentBox.userInteractionEnabled = false
                        }
                        
                        
                    }
                }
                
                }, withCancelBlock: { error in
                    print(error.description)
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
            })
        }
        

    }
    
    func getCommentsDetails(obsCommentsArray: NSArray)
    {
        for j in 0 ..< obsCommentsArray.count
        {
            //            let comments = commentsDictfromExploreView.allValues[j] as! NSDictionary
            //            print(comments)
            //            commentsArray.addObject(comments.objectForKey("comment")!)
            //            commentersArray.addObject(comments.objectForKey("commenter")!)
            
            let myRootRef = FIRDatabase.database().referenceWithPath("comments/\(obsCommentsArray[j])") //Firebase(url:COMMENTS_URL+"\(obsCommentsArray[j])")
            myRootRef.observeEventType(.Value, withBlock: { snapshot in
                
                print(myRootRef)
                print(snapshot.value)
                
                if !(snapshot.value is NSNull)
                {
                    if(snapshot.value!["comment"] != nil)
                    {
                        self.commentsArray.addObject(snapshot.value!["comment"] as! String)
                    }
                    else
                    {
                        self.commentsArray.addObject("No Comment text")
                    }
                    
                    //if(snapshot.value["commenter"] != nil)
                    //{
                    self.commentersArray.addObject(snapshot.value!["commenter"] as! String)
                    //                    }
                    //                    else
                    //                    {
                    //                        //self.commentersArray.addObject("")
                    //                    }
                    
                    
                    
                }
                
                self.commentsTableView.reloadData()
                
                }, withCancelBlock: { error in
                    print(error.description)
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)

            })
            
        }

    }
    
    func getUpdatedComments()
    {
        let observationRootRef = FIRDatabase.database().referenceWithPath("observations/" + String(observationId)) //Firebase(url:ALL_OBSERVATIONS_URL + observationId)
        observationRootRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(observationRootRef)
            print(snapshot.value!.count)
            
            if !(snapshot.value is NSNull)
            {
                
                    //let observationData = snapshot.value.allValues[i] as! NSDictionary
                    
                    
                    if(snapshot.value!.objectForKey("comments") != nil)
                    {
                        let tempcomments = snapshot.value!.objectForKey("comments") as! NSDictionary
                        print(tempcomments)
                        let commentsKeysArray = tempcomments.allKeys as NSArray
                        self.detailed_commentsDictArray.addObject(commentsKeysArray)
                        
                        
                        self.detailed_commentsCount = commentsKeysArray.count
                    }
                    else
                    {
                        let tempcomments = NSArray()
                        self.detailed_commentsDictArray.addObject(tempcomments)
                        
                        self.detailed_commentsCount = 0
                    }
                
                print(self.observationCommentsArrayfromExploreView)
                
                print(self.detailed_commentsDictArray[0])
                print(self.detailed_commentsCount)
                
                self.commentsArray.removeAllObjects()
                self.commentersArray.removeAllObjects()
                
                self.getCommentsDetails(self.detailed_commentsDictArray[0] as! NSArray)
                
                //self.commentsTableView.reloadData()
                    
//                    if(snapshot.value.objectForKey("likes") != nil)
//                    {
//                        let likesDictionary = snapshot.value.objectForKey("likes") as! NSDictionary
//                        print(likesDictionary.allValues)
//                        
//                        let likesArray = likesDictionary.allValues as NSArray
//                        print(likesArray)
//                        
//                        
//                        for l in 0 ..< likesArray.count
//                        {
//                            if(likesArray[l] as! NSObject == 1)
//                            {
//                                self.likesCount += 1
//                            }
//                        }
//                        print(self.likesCount)
//                        
//                        
//                        self.likesCountArray.addObject("\(self.likesCount)")
//                        
//                        
//                    }
//                    else
//                    {
//                        self.likesCountArray.addObject("0")
//                    }
            }
            
            }, withCancelBlock: { error in
                print(error.description)
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)

            })


    }
    func getUpdatedlikestoDesignIdeas()
    {
        let observationRootRef = FIRDatabase.database().referenceWithPath("ideas/" + String(observationId)) //Firebase(url:POST_IDEAS_URL + observationId)
        observationRootRef.observeEventType(.Value, withBlock: { snapshot in
            
            self.likesCount = 0
            self.dislikesCount = 0
            
            print(observationRootRef)
            print(snapshot.value)
            
            if !(snapshot.value is NSNull)
            {
                
                if(snapshot.value!.objectForKey("likes") != nil)
                {
                    let likesDictionary = snapshot.value!.objectForKey("likes") as! NSDictionary
                    print(likesDictionary.allValues)
                    
                    let likesArray = likesDictionary.allValues as NSArray
                    print(likesArray)
                    
                    let userKeys = likesDictionary.allKeys as NSArray
                    print(userKeys)
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    var userID = String()
                    if(userDefaults.objectForKey("userID") != nil)
                    {
                        userID = (userDefaults.objectForKey("userID") as? String)!
                    }

                    if((userDefaults.stringForKey("isSignedIn")) == "true")
                    {
                        if(userKeys.containsObject(userID))
                        {
                            if(likesDictionary.objectForKey(userID) as! NSObject == 1)
                            {
                                self.isUserLiked = true
                                self.isUserDisLiked = false
                                self.likeButtonForDesign.selected = true
                                self.dislikeButtonForDesign.selected = false
                                
                                self.likeButtonForDesign.userInteractionEnabled = false
                                self.dislikeButtonForDesign.userInteractionEnabled = true
                            }
                            else
                            {
                                self.isUserDisLiked = true
                                self.isUserLiked = false
                                
                                self.likeButtonForDesign.selected = false
                                self.dislikeButtonForDesign.selected = true
                                
                                self.likeButtonForDesign.userInteractionEnabled = true
                                self.dislikeButtonForDesign.userInteractionEnabled = false
                            }
                        }
                        else
                        {
                            self.likeButtonForDesign.selected = false
                            self.dislikeButtonForDesign.selected = false
                            
                            self.likeButtonForDesign.userInteractionEnabled = true
                            self.dislikeButtonForDesign.userInteractionEnabled = true

                        }

                    }
                    else{
                        
                        self.likeButtonForDesign.selected = false
                        self.dislikeButtonForDesign.selected = false
                        
                        self.likeButtonForDesign.userInteractionEnabled = false
                        self.dislikeButtonForDesign.userInteractionEnabled = false
                    }
                    
                    
                    for l in 0 ..< likesArray.count
                    {
                        if(likesArray[l] as! NSObject == 1)
                        {
                            self.likesCount += 1
                        }
                        else
                        {
                            self.dislikesCount += 1
                        }
                    }
                    print(self.likesCount)
                    print(self.dislikesCount)
                    
                }
                else
                {
                    self.likesCount = 0
                    self.dislikesCount = 0
                }

                self.likesCountLabel.text = "\(self.likesCount)"
                self.dislikesCountLabel.text = "\(self.dislikesCount)"
                
                print(self.likesCount)
                print(self.dislikesCount)
            }
            
            
            
            }, withCancelBlock: { error in
                print(error.description)
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)

        })
        
        
    }



    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentsTableViewCell
        
        cell.commentLabel.text = commentsArray[indexPath.row] as? String
        
        //cell.commentorAvatarImageView.layer.cornerRadius = 20.0
        
        
        let geoActivitiesRootRef = FIRDatabase.database().referenceWithPath("users/" + String(self.commentersArray[indexPath.row])) //Firebase(url:USERS_URL+(self.commentersArray[indexPath.row] as! String))
        geoActivitiesRootRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(geoActivitiesRootRef)
            //print(snapshot.value!.count)
            
            if !(snapshot.value is NSNull)
            {
                
                
                //print(observerData.objectForKey("affiliation"))
                //print(observerData.objectForKey("display_name"))
                //print(observerData)
                if((snapshot.value!.objectForKey("affiliation")) != nil)
                {
                    let observerAffiliationString = snapshot.value!.objectForKey("affiliation") as! String
                    cell.commentorDateLabel.text = observerAffiliationString
                    //observerAffiliationsArray.addObject(observerAffiliationString)
                    print(observerAffiliationString)
                }
                else
                {
                    cell.commentorDateLabel.text = "No Affiliation"
                }
                
                if((snapshot.value!.objectForKey("display_name")) != nil)
                {
                    let observerDisplayNameString = snapshot.value!.objectForKey("display_name") as! String
                    cell.commentorNameLabel.text = observerDisplayNameString
                    //observerNamesArray.addObject(observerDisplayNameString)
                }
                else
                {
                    cell.commentorNameLabel.text = ""
                }
                
                //print(observerAffiliation)
                //print(observerDisplayName)
                if((snapshot.value!.objectForKey("avatar")) != nil)
                {
                    let observerAvatar = snapshot.value!.objectForKey("avatar")
                    let observerAvatarUrl  = NSURL(string: observerAvatar as! String)
                    //if(UIApplication.sharedApplication().canOpenURL(observerAvatarUrl!) == true)
                    //{
                        //let observerAvatarData = NSData(contentsOfURL: observerAvatarUrl!)
                        //cell.commentorAvatarImageView.image = UIImage(data: observerAvatarData!)
                        cell.commentorAvatarImageView.kf_setImageWithURL(observerAvatarUrl!, placeholderImage: UIImage(named: "user.png"))
                        
//                    }
//                    else
//                    {
//                        cell.commentorAvatarImageView.image = UIImage(named:"user.png")
//                    }
                    //                            if let observerAvatarUrl  = NSURL(string: observerAvatar as! String),
                    //                                observerAvatarData = NSData(contentsOfURL: observerAvatarUrl)
                    //                            {
                    //                                if(UIApplication.sharedApplication().canOpenURL(observerAvatarUrl) == true)
                    //                                {
                    //                                    cell.commentorAvatarImageView.image = UIImage(data: observerAvatarData)
                    //                                }
                    //                                else
                    //                                {
                    //                                     cell.commentorAvatarImageView.image = UIImage(named:"user.png")
                    //                                }
                    //
                    //                                //observerAvatarsArray.addObject(observerAvatar!)
                    //                                //self.observerAvatarUrlString = observerAvatar as! String
                    //                            }
                }
                else
                {
                    cell.commentorAvatarImageView.image = UIImage(named:"user.png")
                    
                }

            }
            
            
            
            }, withCancelBlock: { error in
                print(error.description)
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)

        })

        
//                let url = NSURL(string: USERS_URL+"\(self.commentersArray[indexPath.row]).json")
//                var userData:NSData? = nil
//                do {
//                    userData = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
//                    print(userData)
//                }
//                catch {
//                    print("Handle \(error) here")
//                }
//                
//                if let data = userData {
//                    // Convert data to JSON here
//                    do{
//                        let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
//                        print(json)
//                        
//                        cell.commentorAvatarImageView.layer.cornerRadius = 20.0
//                        
//                        //print(observerData.objectForKey("affiliation"))
//                        //print(observerData.objectForKey("display_name"))
//                        //print(observerData)
//                        if((json.objectForKey("affiliation")) != nil)
//                        {
//                            let observerAffiliationString = json.objectForKey("affiliation") as! String
//                           cell.commentorDateLabel.text = observerAffiliationString
//                            //observerAffiliationsArray.addObject(observerAffiliationString)
//                            print(observerAffiliationString)
//                        }
//                        else
//                        {
//                            cell.commentorDateLabel.text = "No Affiliation"
//                        }
//                        
//                        if((json.objectForKey("display_name")) != nil)
//                        {
//                            let observerDisplayNameString = json.objectForKey("display_name") as! String
//                            cell.commentorNameLabel.text = observerDisplayNameString
//                            //observerNamesArray.addObject(observerDisplayNameString)
//                        }
//                        else
//                        {
//                            cell.commentorNameLabel.text = ""
//                        }
//                        
//                        //print(observerAffiliation)
//                        //print(observerDisplayName)
//                        if((json.objectForKey("avatar")) != nil)
//                        {
//                            let observerAvatar = json.objectForKey("avatar")
//                            let observerAvatarUrl  = NSURL(string: observerAvatar as! String)
//                            if(UIApplication.sharedApplication().canOpenURL(observerAvatarUrl!) == true)
//                            {
//                                let observerAvatarData = NSData(contentsOfURL: observerAvatarUrl!)
//                                cell.commentorAvatarImageView.image = UIImage(data: observerAvatarData!)
//                            }
//                            else
//                            {
//                                cell.commentorAvatarImageView.image = UIImage(named:"user.png")
//                            }
////                            if let observerAvatarUrl  = NSURL(string: observerAvatar as! String),
////                                observerAvatarData = NSData(contentsOfURL: observerAvatarUrl)
////                            {
////                                if(UIApplication.sharedApplication().canOpenURL(observerAvatarUrl) == true)
////                                {
////                                    cell.commentorAvatarImageView.image = UIImage(data: observerAvatarData)
////                                }
////                                else
////                                {
////                                     cell.commentorAvatarImageView.image = UIImage(named:"user.png")
////                                }
////                                
////                                //observerAvatarsArray.addObject(observerAvatar!)
////                                //self.observerAvatarUrlString = observerAvatar as! String
////                            }
//                        }
//                        else
//                        {
//                            cell.commentorAvatarImageView.image = UIImage(named:"user.png")
//                            
//                        }
//                        
//                        
//                        
//                    }catch let error as NSError {
//                        print("json error: \(error.localizedDescription)")
//                        let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
//        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    @IBAction func postComment(sender: UIButton) {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var userID = String()
        if(userDefaults.objectForKey("userID") != nil)
        {
            userID = (userDefaults.objectForKey("userID") as? String)!
        }
     
        print(userID)
        
        if(commentTF.text != "")
        {
            var email = ""
            var password = ""
            
            
            if(userDefaults.objectForKey("email") as? String != nil || userDefaults.objectForKey("password") as? String != nil)
            {
                email = (userDefaults.objectForKey("email") as? String)!
                password = (userDefaults.objectForKey("password") as? String)!
            }
            
            
            
            print(email)
            print(password)
            
            let refUser = FIRAuth.auth()
            refUser!.signInWithEmail(email, password: password,
                             completion: { authData, error in
                                if error != nil {
                                    
                                    print("\(error)")
                                    
                                    var alert = UIAlertController()
                                    if(email == "")
                                    {
                                        alert = UIAlertController(title: "Alert", message:"Please Login to continue" ,preferredStyle: UIAlertControllerStyle.Alert)
                                    }
                                    else
                                    {
                                        alert = UIAlertController(title: "Alert", message:error.debugDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                    }

                                    
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    
                                }
                                else
                                {
                                    
                                    let commentsRef = FIRDatabase.database().referenceWithPath("comments/")
                                    let autoID = commentsRef.childByAutoId()
                                    
                                    print(autoID.key)
                                    
                                    let commentData = ["id": autoID.key as AnyObject,"context": self.commentContext as AnyObject,"commenter": userID as AnyObject,"comment": self.commentTF.text as! AnyObject,"parent": self.observationId as AnyObject, "created_at": FIRServerValue.timestamp(),"updated_at": FIRServerValue.timestamp()]
                                    autoID.setValue(commentData)
                                    
                                    
//                                    let commentChild = autoID.childByAppendingPath("comment")
//                                    commentChild.setValue(self.commentTF.text)
//                                    
//                                    let contextChild = autoID.childByAppendingPath("context")
//                                    contextChild.setValue(self.commentContext)
//                                    
//                                    let commenterChild = autoID.childByAppendingPath("commenter")
//                                    commenterChild.setValue(userID)
//                                    
//                                    let idChild = autoID.childByAppendingPath("id")
//                                    idChild.setValue(autoID.key)
//                                    
//                                    let parentChild = autoID.childByAppendingPath("parent")
//                                    parentChild.setValue(userID)
//                                    
//                                    let createdAtChild = autoID.childByAppendingPath("created_at")
//                                    createdAtChild.setValue(FirebaseServerValue.timestamp())
//                                    
//                                    let updatedAtChild = autoID.childByAppendingPath("updated_at")
//                                    updatedAtChild.setValue(FirebaseServerValue.timestamp())
                                    
                                    let ref = FIRDatabase.database()
                                    
                                    if(self.isfromDesignIdeasView == true)
                                    {
                                        ref.referenceWithPath("ideas/\(self.observationId)/comments")
                                        //Firebase(url: POST_IDEAS_URL+"\(self.observationId)/comments")
                                    }
                                    else
                                    {
                                        ref.referenceWithPath("observations/\(self.observationId)/comments")
                                    }
                                    
                                    
                                    //print(ref.childByAutoId())
                                    //let autoID = ref.childByAutoId()
                                    //let obsRef = ref.childByAutoId().childByAppendingPath(ref.AutoId())
                                    let commentidChild = ref.reference().child(autoID.key) //childByAppendingPath(autoID.key)
                                    commentidChild.setValue(true)
                                    
                                    
                                    //self.getUpdatedComments()
                                    
                                    let alert = UIAlertController(title: "Alert", message: "Comment Posted Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                                self.getUpdatedComments()
                                    
            })
        
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Text in the Comment Field to Post it", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
        
        
    }
    @IBAction func likeButtonClicked(sender: UIButton) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if((userDefaults.stringForKey("isSignedIn")) == "true")
        {
            if(isUserLiked == true)
            {
                
                let alert = UIAlertController(title: "Alert", message: "You Already liked this post", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else
            {
                postLiketoDesign(true)
            }
            
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Please Sign In to like", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func dislikeButtonClicked(sender: UIButton) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if((userDefaults.stringForKey("isSignedIn")) == "true")
        {
            if(isUserDisLiked == true)
            {
                let alert = UIAlertController(title: "Alert", message: "You Already disliked this post", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                postLiketoDesign(false)
            }
//            sender.selected = true
//            sender.userInteractionEnabled = false
//            likeButtonForDesign.userInteractionEnabled = true
            
        }
        else{
            
            let alert = UIAlertController(title: "Alert", message: "Please Sign In to dislike", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func likeButtonBesidesCommentBoxClicked(sender: UIButton) {
        
        //sender.setImage(UIImage(named: "4-6 like-grey.png") as UIImage?, forState: .Selected)
        //sender.selected = true
        //postLiketoObservation()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if((userDefaults.stringForKey("isSignedIn")) == "true")
        {
            if(isObservationLiked == true)
            {
                let alert = UIAlertController(title: "Alert", message: "You Already liked this post", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                postLiketoObservation()
            }
            
        }
        else{
            
            let alert = UIAlertController(title: "Alert", message: "Please Sign In to like this post", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

        
    }
    func postLiketoDesign(islike: Bool)
    {
//        likesCountFromDesignIdeasView += 1
//        dislikesCountFromDesignIdeasView += 1
//        
//        likesCountLabel.text = "\(likesCountFromDesignIdeasView)"
//        dislikesCountLabel.text = "\(dislikesCountFromDesignIdeasView)"
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var userID = String()
        if(userDefaults.objectForKey("userID") != nil)
        {
            userID = (userDefaults.objectForKey("userID") as? String)!
        }
        var email = ""
        var password = ""
        
        
        if(userDefaults.objectForKey("email") as? String != nil || userDefaults.objectForKey("password") as? String != nil)
        {
            email = (userDefaults.objectForKey("email") as? String)!
            password = (userDefaults.objectForKey("password") as? String)!
        }

        
        print(userID)
        
        let refUser = FIRAuth.auth()
        refUser!.signInWithEmail(email, password: password,
                         completion: { authData, error in
                            if error != nil {
                                
                                print("\(error)")
                                var alert = UIAlertController()
                                if(email == "")
                                {
                                    alert = UIAlertController(title: "Alert", message:"Please Login to continue" ,preferredStyle: UIAlertControllerStyle.Alert)
                                }
                                else
                                {
                                    alert = UIAlertController(title: "Alert", message:error.debugDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                }

                                //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                //                                let showMenuAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                                //                                    UIAlertAction in
                                //                                    //print("OK Pressed")
                                //                                    //self.dismissVC()
                                //
                                //                                    let signInSignUpVC=SignInSignUpViewController()
                                //                                    let signInSignUpNavVC = UINavigationController()
                                //                                    signInSignUpVC.pageTitle="Sign In"
                                //                                    signInSignUpNavVC.viewControllers = [signInSignUpVC]
                                //                                    self.presentViewController(signInSignUpNavVC, animated: true, completion: nil)
                                //                                }
                                //
                                //                                // Add the actions
                                //                                alert.addAction(showMenuAction)
                                //                                
                                //                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                
                            }
                            else
                            {
                                if(userID != "")
                                {
                                    print(POST_IDEAS_URL+"\(self.designID)/likes")
                                    
                                    let ref = FIRDatabase.database().referenceWithPath("ideas/"+"\(self.designID)/likes")
                                    //Firebase(url: POST_IDEAS_URL+"\(self.designID)/likes")
                                    //print(ref.childByAutoId())
                                    //let autoID = ref.childByAutoId()
                                    //let obsRef = ref.childByAutoId().childByAppendingPath(ref.AutoId())
                                    let userChild = ref.childByAppendingPath(userID)
                                    userChild.setValue(islike)
                                    print(self.designID)
                                    
                                    var errMsg = ""
                                    
                                    if(islike == true)
                                    {
                                        errMsg = "Liked Successfully"
                                    }
                                    else
                                    {
                                        errMsg = "DisLiked Successfully"
                                    }
                                    
                                    let alert = UIAlertController(title: "Alert", message: errMsg, preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    
                                    self.getUpdatedlikestoDesignIdeas()
                                }
                                else
                                {
                                    let alert = UIAlertController(title: "Alert", message: "Please Sign In to like the Design", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }

                            }
        })

        
        
    }
    
    func postLiketoObservation()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var userID = String()
        if(userDefaults.objectForKey("userID") != nil)
        {
            userID = (userDefaults.objectForKey("userID") as? String)!
        }
        
        print(userID)
        
        var email = ""
        var password = ""
        
        
        if(userDefaults.objectForKey("email") as? String != nil || userDefaults.objectForKey("password") as? String != nil)
        {
            email = (userDefaults.objectForKey("email") as? String)!
            password = (userDefaults.objectForKey("password") as? String)!
        }

        
        let refUser = FIRAuth.auth()
        refUser!.signInWithEmail(email, password: password,
                         completion: { authData, error in
                            if error != nil {
                                
                                print("\(error)")
                                
                                var alert = UIAlertController()
                                if(email == "")
                                {
                                    alert = UIAlertController(title: "Alert", message:"Please Login to continue" ,preferredStyle: UIAlertControllerStyle.Alert)
                                }
                                else
                                {
                                    alert = UIAlertController(title: "Alert", message:error.debugDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                }
                                
                                //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                                let showMenuAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
//                                    UIAlertAction in
//                                    //print("OK Pressed")
//                                    //self.dismissVC()
//                                    
//                                    let signInSignUpVC=SignInSignUpViewController()
//                                    let signInSignUpNavVC = UINavigationController()
//                                    signInSignUpVC.pageTitle="Sign In"
//                                    signInSignUpNavVC.viewControllers = [signInSignUpVC]
//                                    self.presentViewController(signInSignUpNavVC, animated: true, completion: nil)
//                                }
//                                
//                                // Add the actions
//                                alert.addAction(showMenuAction)
//                                
//                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                
                            }
                            else
                            {
                                //let userDefaults = NSUserDefaults.standardUserDefaults()
                                //userDefaults.setValue("false", forKey: "isObservationLiked")
                                if(userID != "" || self.observationId != "")
                                {
                                    let ref = FIRDatabase.database().referenceWithPath("observations/\(self.observationId)/likes") //Firebase(url: POST_OBSERVATION_URL+"\(self.observationId)/likes")
                                    //print(ref.childByAutoId())
                                    //let autoID = ref.childByAutoId()
                                    //let obsRef = ref.childByAutoId().childByAppendingPath(ref.AutoId())
                                    let userChild = ref.childByAppendingPath(userID)
                                    userChild.setValue(true)
                                    print(self.observationId)
                                    
                                    
                                    
                                    //userDefaults.setValue("true", forKey: "isObservationLiked")
                                    
                                    let alert = UIAlertController(title: "Alert", message: "Liked Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    
                                    self.getLikesToObservations()
                                }
                                else
                                {
                                    let alert = UIAlertController(title: "Alert", message: "Please Sign In to like the Observation", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }

                                
                            }})

        
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
