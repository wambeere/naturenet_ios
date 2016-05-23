//
//  DesignIdeasViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/20/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class DesignIdeasViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var designIdeasButton: UIButton!
    @IBOutlet weak var designChallengesButton: UIButton!
    
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var designLabel: UILabel!
    @IBOutlet weak var designDescrptionLabel: UILabel!
    
    @IBOutlet weak var designTableView: UITableView!
    
    var submitterAffiliation : NSMutableArray = []
    var submitterDisplayName : NSMutableArray = []
    var submitterAvatar : NSMutableArray = []
    
    var submitterAffiliation_ideas : NSMutableArray = []
    var submitterDisplayName_ideas : NSMutableArray = []
    var submitterAvatar_ideas : NSMutableArray = []
    
    var submitterAffiliation_challenges : NSMutableArray = []
    var submitterDisplayName_challenges : NSMutableArray = []
    var submitterAvatar_challenges : NSMutableArray = []
    
    
    var contentArray: NSMutableArray = []
    var contentArray_ideas: NSMutableArray = []
    var contentArray_challenges: NSMutableArray = []
    
    
    var groupChallengeArray: NSMutableArray = []
    var groupDesignArray: NSMutableArray = []
    var groupArray: NSMutableArray = []
    
    @IBOutlet weak var recentContributionsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 290
            let barButtonItem = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.leftBarButtonItem = barButtonItem
            
        }
        
        self.navigationItem.title="DESIGN IDEAS"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        designIdeasButton.selected = true
        
        designImageView.image = UIImage(named: "add design ideas.png")
        designLabel.text = "DESIGN IDEAS"
        designDescrptionLabel.text = "Your design ideas can be a new way of using NatureNet in your community, and new mobile technology for learning about sustainability or changes in the environment, or a new feature for the app."
        
        designTableView.delegate = self
        designTableView.dataSource = self
        designTableView.separatorColor = UIColor.clearColor()
        
        designTableView.registerNib(UINib(nibName: "DesignIdeasAndChallengesTableViewCell", bundle: nil), forCellReuseIdentifier: "designIdeasAndChallengesIdentifier")
        
        
        
        let ideasUrl = NSURL(string: DESIGN_URL)
        
        var ideasData:NSData? = nil
        do {
            ideasData = try NSData(contentsOfURL: ideasUrl!, options: NSDataReadingOptions())
            //print(userData)
        }
        catch {
            print("Handle \(error) here")
        }
        
        if let data = ideasData {
            // Convert data to JSON here
            do{
                let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
                
                print(json)
                
                for i in 0 ..< json.count
                {
                    //print(i)
                    let ideasDetailData = json.allValues[i] as! NSDictionary
                    print(ideasDetailData.objectForKey("content"))
                    print(ideasDetailData.objectForKey("group"))
                    //print(ideasDetailData.objectForKey("submitter"))
//                    if(ideasDetailData.objectForKey("content") != nil)
//                    {
//                        contentArray.addObject(ideasDetailData.objectForKey("content")!)
//                    }
//                    else
//                    {
//                        contentArray.addObject("No Content")
//                    }
                    let submitter = ideasDetailData.objectForKey("submitter") as! String
                    //print(submitter)
                    
                    let designGroup = ideasDetailData.objectForKey("group") as? String
                    
                    if(ideasDetailData.objectForKey("group") != nil)
                    {
                        
                        if(designGroup == "Challenge")
                        {
                            if(ideasDetailData.objectForKey("content") != nil)
                            {
                                contentArray_challenges.addObject(ideasDetailData.objectForKey("content")!)
                            }
                            else
                            {
                                contentArray_challenges.addObject("No Content")
                            }
                            
                            if(submitter != "")
                            {
                                let submitterurl = NSURL(string: USERS_URL+"\(submitter).json")
                                var submitterData:NSData? = nil
                                do {
                                    submitterData = try NSData(contentsOfURL: submitterurl!, options: NSDataReadingOptions())
                                    print(submitterData)
                                }
                                catch {
                                    print("Handle \(error) here")
                                }
                                
                                if let data = submitterData {
                                    // Convert data to JSON here
                                    do{
                                        let submitterjson: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
                                        print(submitterjson)
                                        
                                        //print(observerData.objectForKey("affiliation"))
                                        //print(observerData.objectForKey("display_name"))
                                        //print(observerData)
                                        if((submitterjson.objectForKey("affiliation")) != nil)
                                        {
                                            let submiterAffiliationString = submitterjson.objectForKey("affiliation") as! String
                                            
                                            submitterAffiliation_challenges.addObject(submiterAffiliationString)
                                            
                                        }
                                        else
                                        {
                                            submitterAffiliation_challenges.addObject("")
                                        }
                                        
                                        if((submitterjson.objectForKey("display_name")) != nil)
                                        {
                                            let submitterDisplayNameString = submitterjson.objectForKey("display_name") as! String
                                            
                                            submitterDisplayName_challenges.addObject(submitterDisplayNameString)
                                        }
                                        else
                                        {
                                            submitterDisplayName_challenges.addObject("")
                                        }
                                        
                                        //print(observerAffiliation)
                                        //print(observerDisplayName)
                                        if((submitterjson.objectForKey("avatar")) != nil)
                                        {
                                            let submitterAvatarString = submitterjson.objectForKey("avatar")
                                            //                                    if let submitterAvatarUrl  = NSURL(string: submitterAvatarString as! String),
                                            //                                        submitterAvatarData = NSData(contentsOfURL: submitterAvatarUrl)
                                            //                                    {
                                            
                                            submitterAvatar_challenges.addObject(submitterAvatarString!)
                                            
                                            //}
                                        }
                                        else
                                        {
                                            submitterAvatar_challenges.addObject(NSBundle.mainBundle().URLForResource("user", withExtension: "png")!)
                                            
                                        }
                                        
                                        
                                        
                                    }catch let error as NSError {
                                        print("json error: \(error.localizedDescription)")
                                        let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                    
                                }
                                
                            }

                        }
                        else
                        {
                            if(ideasDetailData.objectForKey("content") != nil)
                            {
                                contentArray_ideas.addObject(ideasDetailData.objectForKey("content")!)
                            }
                            else
                            {
                                contentArray_ideas.addObject("No Content")
                            }
                            
                            if(submitter != "")
                            {
                                let submitterurl = NSURL(string: USERS_URL+"\(submitter).json")
                                var submitterData:NSData? = nil
                                do {
                                    submitterData = try NSData(contentsOfURL: submitterurl!, options: NSDataReadingOptions())
                                    print(submitterData)
                                }
                                catch {
                                    print("Handle \(error) here")
                                }
                                
                                if let data = submitterData {
                                    // Convert data to JSON here
                                    do{
                                        let submitterjson: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
                                        print(submitterjson)
                                        
                                        //print(observerData.objectForKey("affiliation"))
                                        //print(observerData.objectForKey("display_name"))
                                        //print(observerData)
                                        if((submitterjson.objectForKey("affiliation")) != nil)
                                        {
                                            let submiterAffiliationString = submitterjson.objectForKey("affiliation") as! String
                                            
                                            submitterAffiliation_ideas.addObject(submiterAffiliationString)
                                            
                                        }
                                        else
                                        {
                                            submitterAffiliation_ideas.addObject("")
                                        }
                                        
                                        if((submitterjson.objectForKey("display_name")) != nil)
                                        {
                                            let submitterDisplayNameString = submitterjson.objectForKey("display_name") as! String
                                            
                                            submitterDisplayName_ideas.addObject(submitterDisplayNameString)
                                        }
                                        else
                                        {
                                            submitterDisplayName_ideas.addObject("")
                                        }
                                        
                                        //print(observerAffiliation)
                                        //print(observerDisplayName)
                                        if((submitterjson.objectForKey("avatar")) != nil)
                                        {
                                            let submitterAvatarString = submitterjson.objectForKey("avatar")
                                            //                                    if let submitterAvatarUrl  = NSURL(string: submitterAvatarString as! String),
                                            //                                        submitterAvatarData = NSData(contentsOfURL: submitterAvatarUrl)
                                            //                                    {
                                            
                                            submitterAvatar_ideas.addObject(submitterAvatarString!)
                                            
                                            //}
                                        }
                                        else
                                        {
                                            submitterAvatar_ideas.addObject(NSBundle.mainBundle().URLForResource("user", withExtension: "png")!)
                                            
                                        }
                                        
                                        
                                        
                                    }catch let error as NSError {
                                        print("json error: \(error.localizedDescription)")
                                        let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                    
                                }
                                
                            }

                        }
                    }
                    else
                    {
                        
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
        
        contentArray = contentArray_ideas
        submitterAvatar = submitterAvatar_ideas
        submitterAffiliation = submitterAffiliation_ideas
        submitterDisplayName = submitterDisplayName_ideas
        
        if(contentArray.count == 0)
        {
            recentContributionsLabel.text = "No Recent Contributions"
            recentContributionsLabel.textAlignment = NSTextAlignment.Center
            recentContributionsLabel.textColor = UIColor.redColor()
        }
        else
        {
            recentContributionsLabel.text = "Recent Contributions"
            recentContributionsLabel.textAlignment = NSTextAlignment.Left
            recentContributionsLabel.textColor = UIColor.blackColor()
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getDesignIdeas(sender: UIButton) {
        
        designIdeasButton.selected = true
        designChallengesButton.selected = false
        self.navigationItem.title="DESIGN IDEAS"
        
        designImageView.image = UIImage(named: "add design ideas.png")
        designLabel.text = "DESIGN IDEAS"
        designDescrptionLabel.text = "Your design ideas can be a new way of using NatureNet in your community, and new mobile technology for learning about sustainability or changes in the environment, or a new feature for the app."
        
        contentArray = contentArray_ideas
        submitterAvatar = submitterAvatar_ideas
        submitterAffiliation = submitterAffiliation_ideas
        submitterDisplayName = submitterDisplayName_ideas
        
        if(contentArray.count == 0)
        {
            recentContributionsLabel.text = "No Recent Contributions"
            recentContributionsLabel.textAlignment = NSTextAlignment.Center
            recentContributionsLabel.textColor = UIColor.redColor()
        }
        else
        {
            recentContributionsLabel.text = "Recent Contributions"
            recentContributionsLabel.textAlignment = NSTextAlignment.Left
            recentContributionsLabel.textColor = UIColor.blackColor()
        }
        
        designTableView.reloadData()
    }

    @IBAction func getDesignChallenges(sender: UIButton) {
        
        designChallengesButton.selected = true
        designIdeasButton.selected = false
        self.navigationItem.title="DESIGN CHALLENGES"
        
        designImageView.image = UIImage(named: "add design challenges.png")
        designLabel.text = "DESIGN CHALLENGES"
        designDescrptionLabel.text = "A design challenge is a question – for example: How can the NatureNet app collect temperature data?"
        
        contentArray = contentArray_challenges
        submitterAvatar = submitterAvatar_challenges
        submitterAffiliation = submitterAffiliation_challenges
        submitterDisplayName = submitterDisplayName_challenges
        
        if(contentArray.count == 0)
        {
            recentContributionsLabel.text = "No Recent Contributions"
            recentContributionsLabel.textAlignment = NSTextAlignment.Center
            recentContributionsLabel.textColor = UIColor.redColor()
        }
        else
        {
            recentContributionsLabel.text = "Recent Contributions"
            recentContributionsLabel.textAlignment = NSTextAlignment.Left
            recentContributionsLabel.textColor = UIColor.blackColor()
        }
        
        designTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("designIdeasAndChallengesIdentifier", forIndexPath: indexPath) as! DesignIdeasAndChallengesTableViewCell
        
        cell.contentLabel.text = contentArray[indexPath.row] as? String
        cell.submitterDisplayName.text = submitterDisplayName[indexPath.row] as? String
        cell.submitterAffiliation.text = submitterAffiliation[indexPath.row] as? String
        
        if let submitterAvatarUrl  = NSURL(string: submitterAvatar[indexPath.row] as! String),
            submitterAvatarData = NSData(contentsOfURL: submitterAvatarUrl)
        {
            cell.submitterAvatarView.image = UIImage(data: submitterAvatarData)
        }
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailedObservationVC = DetailedObservationViewController()
        detailedObservationVC.observerImageUrl = submitterAvatar[indexPath.row] as! String
        detailedObservationVC.observerDisplayName = submitterDisplayName[indexPath.row] as! String
        detailedObservationVC.observerAffiliation = submitterAffiliation[indexPath.row] as! String
        detailedObservationVC.pageTitle = self.navigationItem.title!
        detailedObservationVC.observationImageUrl = NSBundle.mainBundle().URLForResource("obs", withExtension: "png")!.absoluteString
        detailedObservationVC.isfromDesignIdeasView = true
        detailedObservationVC.observationText = contentArray[indexPath.row] as! String
//        detailedObservationVC.commentsDictfromExploreView = commentsDicttoDetailVC
//        detailedObservationVC.observationId = obsevationId
        self.navigationController?.pushViewController(detailedObservationVC, animated: true)
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
