//
//  CommunitiesViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/20/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class CommunitiesViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var peopleCountLabel: UILabel!
    @IBOutlet weak var peopleTable: UITableView!
    
    var userDisplayNamesArray: NSMutableArray = []
    var userAffiliationsArray: NSMutableArray = []
    var userAvatarURLSArray: NSMutableArray = []
    
    let newObsAndDIView_communities = NewObsAndDIViewController()
    let cgVC_communities = CameraAndGalleryViewController()
    let diAndCVC_communities = DesignIdeasAndChallengesViewController()
    
    var usersCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 290
            let barButtonItem = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.leftBarButtonItem = barButtonItem
            
        }
        
        self.navigationItem.title="COMMUNITIES"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        
        peopleTable.delegate = self
        peopleTable.dataSource = self
        peopleTable.separatorColor = UIColor.clearColor()
        peopleTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        peopleTable.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0)
    
        
        
        let usersUrl = NSURL(string: FIREBASE_URL+"users.json")
        
        
        var userData:NSData? = nil
        do {
            userData = try NSData(contentsOfURL: usersUrl!, options: NSDataReadingOptions())
            //print(userData)
        }
        catch {
            print("Handle \(error) here")
        }
        
        if let data = userData {
            // Convert data to JSON here
            do{
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
                
                print(json)
                
                for i in 0 ..< json.count
                {
             
                    //print(json.allValues[i])
                    let userJsonData = json.allValues[i] as! NSDictionary
                    print(userJsonData)
                    usersCount = json.count
                    peopleCountLabel.text = "People" + "(" + "\(usersCount)" + ")"
                    
                    if(userJsonData.objectForKey("display_name") != nil)
                    {
                        let dn = userJsonData.objectForKey("display_name") as? String
                        userDisplayNamesArray.addObject(dn!)
                    }
                    else
                    {
                        userDisplayNamesArray.addObject("NO Display Name")
                    }
                    if(userJsonData.objectForKey("affiliation") != nil)
                    {
                        let aff = userJsonData.objectForKey("affiliation") as? String
                        userAffiliationsArray.addObject(aff!)
                    }
                    else
                    {
                        userAffiliationsArray.addObject("NO Affiliation")
                    }
                    if(userJsonData.objectForKey("avatar") != nil)
                    {
                        //let avatarUrlString = userJsonData.objectForKey("avatar") as! String
                        //print(avatarUrlString)
                        //let newavatarUrlString = avatarUrlString.stringByReplacingOccurrencesOfString("upload", withString: "upload/t_ios-thumbnail", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let av = userJsonData.objectForKey("avatar") as! String
                        userAvatarURLSArray.addObject(av)
                    }
                    else
                    {
                        userAvatarURLSArray.addObject(NSBundle.mainBundle().URLForResource("user", withExtension: "png")!.absoluteString)
                    }
                }
            }
            
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }

        }
        
        
        newObsAndDIView_communities.view.frame = CGRectMake(0 ,self.view.frame.size.height-newObsAndDIView_communities.view.frame.size.height-8, newObsAndDIView_communities.view.frame.size.width, newObsAndDIView_communities.view.frame.size.height)
        self.view.addSubview(newObsAndDIView_communities.view)
        //self.view.bringSubviewToFront(newObsAndDIView.view)
        newObsAndDIView_communities.camButton.addTarget(self, action: #selector(CommunitiesViewController.openNewObsView_communities), forControlEvents: .TouchUpInside)
        
        newObsAndDIView_communities.designIdeaButton.addTarget(self, action: #selector(CommunitiesViewController.openNewDesignView_communities), forControlEvents: .TouchUpInside)
        
    }
    func openNewObsView_communities()
    {
        //print("gverver")
        self.addChildViewController(cgVC_communities)
        cgVC_communities.view.frame = CGRectMake(0, self.view.frame.size.height - cgVC_communities.view.frame.size.height+68, cgVC_communities.view.frame.size.width, cgVC_communities.view.frame.size.height)
        
        cgVC_communities.closeButton.addTarget(self, action: #selector(ProjectsViewController.closeCamAndGalleryView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(cgVC_communities.view)
        UIView.animateWithDuration(0.3, animations: {
            
            self.cgVC_communities.view.frame = CGRectMake(0, self.view.frame.size.height - self.cgVC_communities.view.frame.size.height+68, self.cgVC_communities.view.frame.size.width, self.cgVC_communities.view.frame.size.height)
            
        }) { (isComplete) in
            
            self.cgVC_communities.didMoveToParentViewController(self)
            
        }
    }
    func openNewDesignView_communities()
    {
        //print("gverver")
        self.addChildViewController(diAndCVC_communities)
        diAndCVC_communities.view.frame = CGRectMake(0, self.view.frame.size.height - diAndCVC_communities.view.frame.size.height+68, diAndCVC_communities.view.frame.size.width, diAndCVC_communities.view.frame.size.height)
        
        diAndCVC_communities.closeButton.addTarget(self, action: #selector(ProjectsViewController.closeDiAndChallengesView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(diAndCVC_communities.view)
        UIView.animateWithDuration(0.3, animations: {
            
            self.diAndCVC_communities.view.frame = CGRectMake(0, self.view.frame.size.height - self.diAndCVC_communities.view.frame.size.height+68, self.diAndCVC_communities.view.frame.size.width, self.diAndCVC_communities.view.frame.size.height)
            
        }) { (isComplete) in
            
            self.diAndCVC_communities.didMoveToParentViewController(self)
            
        }
    }
    func closeCamAndGalleryView()
    {
        cgVC_communities.view.removeFromSuperview()
        cgVC_communities.removeFromParentViewController()
    }
    func closeDiAndChallengesView()
    {
        diAndCVC_communities.view.removeFromSuperview()
        diAndCVC_communities.removeFromParentViewController()
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var cell:UITableViewCell? =
            tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                                   reuseIdentifier: "cell")
        }
                
        //let cellImageView = UIImageView()
        //cellImageView.contentMode = UIViewContentMode.ScaleAspectFit
        //cellImageView.frame = CGRectMake(10, 2, 40, 40)
        
        
        if let userIconUrl  = NSURL(string: userAvatarURLSArray[indexPath.row] as! String),
            userIconData = NSData(contentsOfURL: userIconUrl)
        {
            if(UIApplication.sharedApplication().canOpenURL(userIconUrl) == true)
            {
                cell?.imageView!.image = UIImage(data: userIconData)
            }
            else
            {
                cell?.imageView!.image = UIImage(named: "user.png")
            }
            
        }
        
        //cellImageView.clipsToBounds = true
        //cellImageView.layer.cornerRadius = 20.0
        
        //cell!.contentView.addSubview(cellImageView)
        
        cell?.imageView?.layer.cornerRadius = 20.0
        
        cell!.textLabel?.textAlignment = NSTextAlignment.Center
        cell!.detailTextLabel?.textAlignment = NSTextAlignment.Center
        
        cell!.textLabel?.text = userDisplayNamesArray[indexPath.row] as? String
        cell!.detailTextLabel?.text = userAffiliationsArray[indexPath.row] as? String
        
        //cell.imageView!.image = UIImage(named: projIcons[indexPath.row])
        //cell.imageView!.image = imageWithImage(UIImage(named: projIcons[indexPath.row])!, scaledToSize: CGSize(width: 30, height: 30))
        
        let additionalSeparator = UIView()
        additionalSeparator.frame = CGRectMake(0,cell!.frame.size.height,self.view.frame.size.width,6)
        additionalSeparator.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        cell!.addSubview(additionalSeparator)
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
                
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.frame = CGRectMake(0, 0, 100, 50)
        header.backgroundColor = UIColor.whiteColor()
        
        let sectionImageView = UIImageView()
        sectionImageView.image = UIImage(named: "5-1 people.png")
        sectionImageView.frame = CGRectMake(4, 10 , 30, 30)
        //sectionImageView.backgroundColor = UIColor.redColor()
        header.addSubview(sectionImageView)
        
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.font = UIFont(name: "Futura", size: 14)!
        sectionTitleLabel.textColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)

        sectionTitleLabel.text = "People" + "(" + "\(usersCount)" + ")"
        sectionTitleLabel.frame = CGRectMake(40, 10, 100, 30)
        
        header.addSubview(sectionTitleLabel)
        
        return header
    }
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
//    {
//        
//    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return nil
//    }
    
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
