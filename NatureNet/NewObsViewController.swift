//
//  NewObsViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/13/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class NewObsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var observationDetailsTableView: UITableView!
    @IBOutlet weak var observationImageView: UIImageView!
    var obsImage : UIImage = UIImage(named: "profile_icon.png")!
    
    var items: [String] = ["Description", "Project"]
    
    var projectName : String = ""
    var descText :String = ""
    var userID :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="Observation"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "double_down.png"), style: .Plain, target: self, action: #selector(NewObsViewController.dismissVC))
        navigationItem.leftBarButtonItem = barButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Send", style: .Plain, target: self, action: #selector(NewObsViewController.postObservation))
        rightBarButtonItem.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        observationImageView.image = obsImage
        
        observationDetailsTableView.delegate = self
        observationDetailsTableView.dataSource = self
        observationDetailsTableView.separatorColor = UIColor.clearColor()
        observationDetailsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        observationDetailsTableView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        self.view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)


    }
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func dismissVC(){
        
        //self.navigationController!.dismissViewControllerAnimated(true, completion: {})
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        //self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        //print("abhi")
        
    }
    func postObservation()
    {
        print("post")
//        var observations = Firebase(url: "https://naturenet-staging.firebaseio.com/observations")
//        let obs = ["id": uid as! AnyObject,"display_name": self.joinName.text as! AnyObject, "affiliation": self.joinAffliation.text as! AnyObject]
//        observations.setValue(obs)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if(userDefaults.objectForKey("ObservationDescription") != nil)
        {
            descText = (userDefaults.objectForKey("ObservationDescription") as? String)!
        }
        if(userDefaults.objectForKey("Project") != nil)
        {
            projectName = (userDefaults.objectForKey("Project") as? String)!
        }
        if(userDefaults.objectForKey("userID") != nil)
        {
            userID = (userDefaults.objectForKey("userID") as? String)!
        }
        
        let upImage = UploadImageToCloudinary()
        upImage.uploadToCloudinary(obsImage)
        
        print(projectName)
        print(descText)
        print(userID)
        print(OBSERVATION_IMAGE_UPLOAD_URL)
        
        let email = userDefaults.objectForKey("email") as? String
        let password = userDefaults.objectForKey("password") as? String
        let obsImageUrl = userDefaults.objectForKey("observationImageUrl") as? String
        
        //print(email)
        //print(password)
        print(obsImageUrl)
    
        let refUser = Firebase(url: FIREBASE_URL)
        refUser.authUser(email, password: password,
                     withCompletionBlock: { error, authData in
                        if error != nil {
                            
                            print("\(error)")
                            let alert = UIAlertController(title: "Alert", message:error.userInfo.description ,preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        }
                        else
                        {
        let ref = Firebase(url: POST_OBSERVATION_URL)
        print(ref.childByAutoId())
        let autoID = ref.childByAutoId()
        //let obsRef = ref.childByAutoId().childByAppendingPath(ref.AutoId())
        let obsData = autoID.childByAppendingPath("data")
        let obsDataDetails = obsData.childByAppendingPath("text")
        obsDataDetails.setValue(self.descText)
        let obsDataImageDetails = obsData.childByAppendingPath("image")
        obsDataImageDetails.setValue(obsImageUrl)
        let obsDataIgnoreDetails = obsData.childByAppendingPath("ignore")
        obsDataIgnoreDetails.setValue("true")
        
        let obsIdKey = autoID.childByAppendingPath("observer")
        obsIdKey.setValue(self.userID)
        
        
                        }})

        //let usersPrivateReftoid = usersRef.childByAppendingPath("private")
        //let usersPrivate = ["email": self.joinEmail.text as! AnyObject]
        //usersRef.setValue(usersPub)
        //OBSERVATION_IMAGE_UPLOAD_URL = ""
        
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.frame = CGRectMake(8,cell.frame.size.height+3,self.view.frame.size.width-16,cell.frame.size.height)
        
        let additionalSeparator = UIView()
        additionalSeparator.frame = CGRectMake(0,cell.frame.size.height-3,self.view.frame.size.width,3)
        additionalSeparator.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)

        cell.addSubview(additionalSeparator)

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let obsDetailsVC = NewObservationDetailsViewController()
        if(indexPath.row == 0)
        {
            obsDetailsVC.isDescription = true
        }
        else
        {
            obsDetailsVC.isDescription = false
        }
        let navVC = UINavigationController()
        navVC.viewControllers = [obsDetailsVC]
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
