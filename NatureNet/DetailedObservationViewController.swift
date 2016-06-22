//
//  DetailedObservationViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/20/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Firebase


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
    var isfromDesignIdeasView : Bool = false
    var designID: String = ""
    
    
    var observationId : String = ""
    var commentsDictfromExploreView : NSDictionary = [:]
    var observationCommentsArrayfromExploreView : NSArray = []
    
    var pageTitle: String = ""
    
    var commentContext : String = ""
    
    
    
    @IBOutlet weak var likedislikeView: UIView!
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var dislikesCountLabel: UILabel!
    
    var likesCountFromDesignIdeasView : Int = 0
    var dislikesCountFromDesignIdeasView : Int = 0
    @IBOutlet weak var likeButtonBesidesCommentBox: UIButton!
    
    
    
    @IBOutlet weak var commentTF: UITextField!
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
        
        print(observerImageUrl)
        print(observerDisplayName)
        print(observerAffiliation)
        print(observationImageUrl)
        
        print(commentsDictfromExploreView)
        
        print(observationCommentsArrayfromExploreView)
        
        likedislikeView.hidden = true
        
        if(isfromDesignIdeasView)
        {
            likedislikeView.hidden = false
            likeButtonBesidesCommentBox.hidden = true
            
            likesCountLabel.text = "\(likesCountFromDesignIdeasView)"
            dislikesCountLabel.text = "\(dislikesCountFromDesignIdeasView)"
            
            commentContext = "ideas"
            
            //observationImageView.hidden = true
            
//            likedislikeView.frame = CGRectMake(likedislikeView.frame.origin.x, observationTextLabel.frame.origin.y+observationTextLabel.frame.size.height+8, likedislikeView.frame.size.width, likedislikeView.frame.size.height)
//            commentsTableView.frame = CGRectMake(commentsTableView.frame.origin.x, likedislikeView.frame.origin.y+likedislikeView.frame.size.height+8, commentsTableView.frame.size.width, commentsTableView.frame.size.height)
//            
//            print(likedislikeView.frame)
        }
        
        else
        {
            commentContext = "observations"
        }
        
        
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
        
        for j in 0 ..< observationCommentsArrayfromExploreView.count
        {
//            let comments = commentsDictfromExploreView.allValues[j] as! NSDictionary
//            print(comments)
//            commentsArray.addObject(comments.objectForKey("comment")!)
//            commentersArray.addObject(comments.objectForKey("commenter")!)
            
            let myRootRef = Firebase(url:COMMENTS_URL+"\(observationCommentsArrayfromExploreView[j])")
            myRootRef.observeEventType(.Value, withBlock: { snapshot in
               
                print(myRootRef)
                print(snapshot.value)
                
                if !(snapshot.value is NSNull)
                {
                    if(snapshot.value["comment"] != nil)
                    {
                        self.commentsArray.addObject(snapshot.value["comment"] as! String)
                    }
                    else
                    {
                        self.commentsArray.addObject("No Comment text")
                    }
                    
                    //if(snapshot.value["commenter"] != nil)
                    //{
                        self.commentersArray.addObject(snapshot.value["commenter"] as! String)
//                    }
//                    else
//                    {
//                        //self.commentersArray.addObject("")
//                    }
                    
                    
                    self.commentsTableView.reloadData()
                }
                
                
                
                }, withCancelBlock: { error in
                    print(error.description)
            })

        }
        commentTF.delegate = self
        
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
                        
                        cell.commentorAvatarImageView.layer.cornerRadius = 20.0
                        
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
                            cell.commentorDateLabel.text = "No Affiliation"
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
                            let observerAvatarUrl  = NSURL(string: observerAvatar as! String)
                            if(UIApplication.sharedApplication().canOpenURL(observerAvatarUrl!) == true)
                            {
                                let observerAvatarData = NSData(contentsOfURL: observerAvatarUrl!)
                                cell.commentorAvatarImageView.image = UIImage(data: observerAvatarData!)
                            }
                            else
                            {
                                cell.commentorAvatarImageView.image = UIImage(named:"user.png")
                            }
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
            let email = userDefaults.objectForKey("email") as? String
            let password = userDefaults.objectForKey("password") as? String
            
            print(email)
            print(password)
            
            let refUser = Firebase(url: FIREBASE_URL)
            refUser.authUser(email, password: password,
                             withCompletionBlock: { error, authData in
                                if error != nil {
                                    
                                    print("\(error)")
                                    
                                    var alert = UIAlertController()
                                    if(email == nil)
                                    {
                                        alert = UIAlertController(title: "Alert", message:"Please Login to continue" ,preferredStyle: UIAlertControllerStyle.Alert)
                                    }
                                    else
                                    {
                                        alert = UIAlertController(title: "Alert", message:error.localizedDescription.debugDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                    }

                                    
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    
                                }
                                else
                                {
                                    
                                    let commentsRef = Firebase(url: COMMENTS_URL)
                                    let autoID = commentsRef.childByAutoId()
                                    
                                    print(autoID.key)
                                    
                                    let commentData = ["id": autoID.key as AnyObject,"context": self.commentContext as AnyObject,"commenter": userID as AnyObject,"comment": self.commentTF.text as! AnyObject,"parent": self.observationId as AnyObject, "created_at": FirebaseServerValue.timestamp(),"updated_at": FirebaseServerValue.timestamp()]
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
                                    
                                    var ref = Firebase()
                                    
                                    if(self.isfromDesignIdeasView == true)
                                    {
                                        ref = Firebase(url: POST_IDEAS_URL+"\(self.observationId)/comments")
                                    }
                                    else
                                    {
                                        ref = Firebase(url: POST_OBSERVATION_URL+"\(self.observationId)/comments")
                                    }
                                    
                                    
                                    //print(ref.childByAutoId())
                                    //let autoID = ref.childByAutoId()
                                    //let obsRef = ref.childByAutoId().childByAppendingPath(ref.AutoId())
                                    let commentidChild = ref.childByAppendingPath(autoID.key)
                                    commentidChild.setValue(true)
                                    
                                    
                                    let alert = UIAlertController(title: "Alert", message: "Comment Posted Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                                
                                    
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
        
        sender.selected = true
        postLiketoDesign(true)
        
    }
    
    
    @IBAction func dislikeButtonClicked(sender: UIButton) {
        
        sender.selected = true
        postLiketoDesign(false)
        
    }
    
    @IBAction func likeButtonBesidesCommentBoxClicked(sender: UIButton) {
        
        //sender.setImage(UIImage(named: "4-6 like-grey.png") as UIImage?, forState: .Selected)
        sender.selected = true
        postLiketoObservation()
        
    }
    func postLiketoDesign(islike: Bool)
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var userID = String()
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
                                var alert = UIAlertController()
                                if(email == nil)
                                {
                                    alert = UIAlertController(title: "Alert", message:"Please Login to continue" ,preferredStyle: UIAlertControllerStyle.Alert)
                                }
                                else
                                {
                                    alert = UIAlertController(title: "Alert", message:error.localizedDescription.debugDescription ,preferredStyle: UIAlertControllerStyle.Alert)
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
                                    
                                    let ref = Firebase(url: POST_IDEAS_URL+"\(self.designID)/likes")
                                    //print(ref.childByAutoId())
                                    //let autoID = ref.childByAutoId()
                                    //let obsRef = ref.childByAutoId().childByAppendingPath(ref.AutoId())
                                    let userChild = ref.childByAppendingPath(userID)
                                    userChild.setValue(islike)
                                    print(self.designID)
                                    
                                    let alert = UIAlertController(title: "Alert", message: "Liked Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
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
        
        let email = userDefaults.objectForKey("email") as? String
        let password = userDefaults.objectForKey("password") as? String
        
        let refUser = Firebase(url: FIREBASE_URL)
        refUser.authUser(email, password: password,
                         withCompletionBlock: { error, authData in
                            if error != nil {
                                
                                print("\(error)")
                                
                                var alert = UIAlertController()
                                if(email == nil)
                                {
                                    alert = UIAlertController(title: "Alert", message:"Please Login to continue" ,preferredStyle: UIAlertControllerStyle.Alert)
                                }
                                else
                                {
                                    alert = UIAlertController(title: "Alert", message:error.localizedDescription.debugDescription ,preferredStyle: UIAlertControllerStyle.Alert)
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
                                    
                                    let ref = Firebase(url: POST_OBSERVATION_URL+"\(self.observationId)/likes")
                                    //print(ref.childByAutoId())
                                    //let autoID = ref.childByAutoId()
                                    //let obsRef = ref.childByAutoId().childByAppendingPath(ref.AutoId())
                                    let userChild = ref.childByAppendingPath(userID)
                                    userChild.setValue("true")
                                    print(self.observationId)
                                    
                                    let alert = UIAlertController(title: "Alert", message: "Liked Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
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
