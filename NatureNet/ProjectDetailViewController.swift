//
//  ProjectDetailViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/22/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var projectTitle : String = ""
    var projectIcon : String = ""
    var projectStatus : String = ""
    var projectDescription : String = ""
    var projectIdFromProjectVC: String = ""
    
    @IBOutlet weak var recentContributionLabel: UILabel!
    var observationsImagesArray: NSMutableArray = []
    var observationsTextArray: NSMutableArray = []

    @IBOutlet weak var projectStatusImageView: UIImageView!
    @IBOutlet weak var projectDescriptionTextView: UITextView!
    @IBOutlet weak var projectStatusLabel: UILabel!
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectIconImageView: UIImageView!
    @IBOutlet weak var projectsCollectionView: UICollectionView!
    
    var observersAvatarArray_proj: NSMutableArray = []
    var observersNamesArray_proj: NSMutableArray = []
    var observersAffiliationsArray_proj: NSMutableArray = []
    
    var observersAvatarUrls_proj: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title=projectTitle
        
        if let projectIconUrl  = NSURL(string: projectIcon),
            projectIconData = NSData(contentsOfURL: projectIconUrl)
        {
            projectIconImageView.image = UIImage(data: projectIconData)
        }
        
        projectTitleLabel.text = projectTitle
        projectStatusLabel.text = projectStatus
        if(projectStatus == "Completed")
        {
            projectStatusImageView.hidden = false
        }
        else{
            projectStatusImageView.hidden = true
        }
        projectDescriptionTextView.text = projectDescription
        
        //Setting up collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 200)
        
        projectsCollectionView.collectionViewLayout = layout
        projectsCollectionView.dataSource = self
        projectsCollectionView.delegate = self
        projectsCollectionView!.backgroundColor = UIColor.whiteColor()
        projectsCollectionView.alwaysBounceVertical=true
        
        //Registering custom Cell
        self.projectsCollectionView.registerNib(UINib(nibName: "ProjectDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectDetailCell")
        //self.view.addSubview(collectionView)
        projectsCollectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        
        let geoObservationUrl = NSURL(string: OBSERVATIONS_URL)
        
        var geoObservationData:NSData? = nil
        do {
            geoObservationData = try NSData(contentsOfURL: geoObservationUrl!, options: NSDataReadingOptions())
            //print(userData)
        }
        catch {
            print("Handle \(error) here")
        }
        
        
            if let data = geoObservationData {
                // Convert data to JSON here
                do{
                    let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
                    
                    print(json.allKeys)
                    
                    for i in 0 ..< json.count
                    {
                        let obs = json.allKeys[i] as! String
                        let obsDictionary = json.objectForKey(obs) as! NSDictionary
                        print(obsDictionary)
                        
                        let activity_location = obsDictionary.objectForKey("activity_location") as! String
                        
                        print(activity_location)
                        print(projectIdFromProjectVC)
                        
                        if(activity_location != "")
                        {
                            if(activity_location == projectIdFromProjectVC)
                            {
                                print(obsDictionary.objectForKey("activity_location"))
                                print(obsDictionary.objectForKey("created_at"))
                                print(obsDictionary.objectForKey("observer"))
                                let observationData = obsDictionary.objectForKey("data") as! NSDictionary
                                
                                print(observationData.objectForKey("image"))
                                
                                if(observationData.objectForKey("image") != nil)
                                {
                                    observationsImagesArray.addObject(observationData.objectForKey("image")!)
                                }
                                else
                                {
                                    observationsImagesArray.addObject("")
                                }
                                if(observationData.objectForKey("text") != nil)
                                {
                                    observationsTextArray.addObject(observationData.objectForKey("text")!)
                                }
                                else
                                {
                                    observationsTextArray.addObject("")
                                }
                                print(observationData.objectForKey("text"))
                                
                                let obdId = obsDictionary.objectForKey("observer") as! String
                                let url = NSURL(string: USERS_URL+"\(obdId).json")
                                var userData:NSData? = nil
                                do {
                                    userData = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
                                    print(userData)
                                }
                                catch {
                                    print("Handle \(error) here")
                                }
                                
                                if let observerdata = userData {
                                    // Convert data to JSON here
                                    do{
                                        let observerjson: NSDictionary = try NSJSONSerialization.JSONObjectWithData(observerdata, options: NSJSONReadingOptions()) as! NSDictionary
                                        print(observerjson)
                                        
                                        //print(observerData.objectForKey("affiliation"))
                                        //print(observerData.objectForKey("display_name"))
                                        //print(observerData)
                                        if((observerjson.objectForKey("affiliation")) != nil)
                                        {
                                            let observerAffiliationString = observerjson.objectForKey("affiliation") as! String
                                            observersAffiliationsArray_proj.addObject(observerAffiliationString)
                                            //observerAffiliationsArray.addObject(observerAffiliationString)
                                            print(observerAffiliationString)
                                        }
                                        else
                                        {
                                            observersAffiliationsArray_proj.addObject("")
                                        }
                                        
                                        if((observerjson.objectForKey("display_name")) != nil)
                                        {
                                            let observerDisplayNameString = observerjson.objectForKey("display_name") as! String
                                            observersNamesArray_proj.addObject(observerDisplayNameString)
                                            //observerNamesArray.addObject(observerDisplayNameString)
                                        }
                                        else
                                        {
                                            observersNamesArray_proj.addObject("")
                                        }
                                        
                                        //print(observerAffiliation)
                                        //print(observerDisplayName)
                                        if((observerjson.objectForKey("avatar")) != nil)
                                        {
                                            let observerAvatar = observerjson.objectForKey("avatar")
                                            if let observerAvatarUrl  = NSURL(string: observerAvatar as! String),
                                                observerAvatarData = NSData(contentsOfURL: observerAvatarUrl)
                                            {
                                                observersAvatarArray_proj.addObject(UIImage(data: observerAvatarData)!)
                                                //observerAvatarsArray.addObject(observerAvatar!)
                                                //self.observerAvatarUrlString = observerAvatar as! String
                                            }
                                            observersAvatarUrls_proj.addObject(observerAvatar!)
                                        }
                                        else
                                        {
                                            observersAvatarArray_proj.addObject(UIImage(named:"user.png")!)
                                            observersAvatarUrls_proj.addObject(NSBundle.mainBundle().URLForResource("user", withExtension: "png")!)
                                            
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
                }
                    
                catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }

            
        if(observationsImagesArray.count == 0)
        {
            recentContributionLabel.text = "No Recent Contributions"
            recentContributionLabel.textAlignment = NSTextAlignment.Center
            recentContributionLabel.textColor = UIColor.redColor()
        }
        
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return observationsImagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProjectDetailCell", forIndexPath: indexPath) as! ProjectDetailCollectionViewCell
        
        if let projectObservationImageUrl  = NSURL(string: observationsImagesArray[indexPath.row] as! String),
            projectObservationImageData = NSData(contentsOfURL: projectObservationImageUrl)
        {
            cell.observationProjectImageView.image = UIImage(data: projectObservationImageData)
        }
        
        cell.observerAvatarImageView.image = observersAvatarArray_proj[indexPath.row] as? UIImage
        cell.observerNameLabel.text = observersNamesArray_proj[indexPath.row] as? String
        cell.observerAffiliationLabel.text = observersAffiliationsArray_proj [indexPath.row] as? String
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailedObsVC = DetailedObservationViewController()
        detailedObsVC.observerDisplayName = observersNamesArray_proj[indexPath.row] as! String
        detailedObsVC.observerAffiliation = observersAffiliationsArray_proj[indexPath.row] as! String
        detailedObsVC.observerImageUrl = observersAvatarUrls_proj[indexPath.row] as! String
        detailedObsVC.observationText = observationsTextArray[indexPath.row] as! String
        detailedObsVC.observationImageUrl = observationsImagesArray[indexPath.row] as! String
        self.navigationController?.pushViewController(detailedObsVC, animated: true)
        
    
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
