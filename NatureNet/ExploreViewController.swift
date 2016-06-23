//
//  ExploreViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/19/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ExploreViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var observerIdsfromMapView : NSMutableArray = []
    var commentsDictArrayfromMapView : NSMutableArray = []
    var observationCommentsArrayfromMapView : NSArray = []
    var observationIdsfromMapView : NSMutableArray = []
    
    var exploreObservationsImagesArray : NSArray!
    
    var observerAvatarsArray : NSMutableArray = []
    var observerAvatarsUrlArray : NSMutableArray = []
    var observerNamesArray : NSMutableArray = []
    var observerAffiliationsArray : NSMutableArray = []
    var observationTextArray : NSMutableArray = []
    
    var observationsCount : Int = 0
    
    let newObsAndDIViewtemp = NewObsAndDIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if(isPushed==true)
//        {
//            if self.revealViewController() != nil {
//                self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
//                self.revealViewController().rearViewRevealWidth = 290
//                let barButtonItem = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
//                navigationItem.leftBarButtonItem = barButtonItem
//                
//            }
//
//        }
//        else
//        {
            let barButtonItem = UIBarButtonItem(image: UIImage(named: "double_down.png"), style: .Plain, target: self, action: #selector(ExploreViewController.dismissVC))
            navigationItem.leftBarButtonItem = barButtonItem
        //}
        
        self.navigationItem.title="EXPLORE"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        //Setting up collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 172, height: 172)
        
        collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical=true
        //collectionView.alwaysBounceHorizontal=true
        //collectionView.frame=self.view.frame
        
        //Registering custom Cell
        self.collectionView.registerNib(UINib(nibName: "ExploreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCell")
        //self.view.addSubview(collectionView)
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        
        self.view.addSubview(collectionView)
        print(observationIdsfromMapView)
        print(observationIdsfromMapView.count)
        print(observerIdsfromMapView)
        print(observerIdsfromMapView.count)
        
        
        
        for i in 0 ..< observerIdsfromMapView.count
        {
            let usersRootRef = Firebase(url:USERS_URL+"\(observerIdsfromMapView[i])")
            usersRootRef.observeEventType(.Value, withBlock: { snapshot in
                
                print(usersRootRef)
                //print(snapshot.value.count)
                //self.observerNamesArray = []
                
                if !(snapshot.value is NSNull)
                {
                    if((snapshot.value.objectForKey("affiliation")) != nil)
                    {
                        let observerAffiliationString = snapshot.value.objectForKey("affiliation") as! String
                        
                        self.observerAffiliationsArray.addObject(observerAffiliationString)
                    }
                    else
                    {
                        self.observerAffiliationsArray.addObject("")
                    }
                    if((snapshot.value.objectForKey("display_name")) != nil)
                    {
                        let observerDisplayNameString = snapshot.value.objectForKey("display_name") as! String
                        self.observerNamesArray.addObject(observerDisplayNameString)
                    }
                    else
                    {
                        self.observerNamesArray.addObject("")
                    }
                    
                    
                    
                    
                    //print(observerAffiliation)
                    //print(observerDisplayName)
                    if((snapshot.value.objectForKey("avatar")) != nil)
                    {
                        let observerAvatar = snapshot.value.objectForKey("avatar")
                        print(observerAvatar)
                        let observerAvatarUrl  = NSURL(string: observerAvatar as! String)
                        if(UIApplication.sharedApplication().canOpenURL(observerAvatarUrl!) == true)
                        {
                            //self.observerAvatarsArray.addObject(NSData(contentsOfURL: observerAvatarUrl!)!)
                            self.observerAvatarsUrlArray.addObject(observerAvatar!)
                        }
                        else
                        {
                            let tempImageUrl = NSBundle.mainBundle().URLForResource("user", withExtension: "png")
                            
                            
                            //self.observerAvatarsArray.addObject(NSData(contentsOfURL: tempImageUrl!)!)
                            self.observerAvatarsUrlArray.addObject((tempImageUrl?.absoluteString)!)
                        }
                        //let observerAvatarData = NSData(contentsOfURL: observerAvatarUrl!)
                    }
                    else
                    {
                        let tempImageUrl = NSBundle.mainBundle().URLForResource("user", withExtension: "png")
                        
                        //self.observerAvatarsArray.addObject(NSData(contentsOfURL: tempImageUrl!)!)
                        self.observerAvatarsUrlArray.addObject((tempImageUrl?.absoluteString)!)
                        
                    }
                    self.observationsCount = self.observationIdsfromMapView.count
                    print(self.observationsCount)
                    self.collectionView.reloadData()
                    
                }
                
                }, withCancelBlock: { error in
                    print(error.description)
            })

            
//            let url = NSURL(string: USERS_URL+"\(observerIdsfromMapView[i]).json")
//            var userData:NSData? = nil
//            do {
//                userData = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
//                print(userData)
//            }
//            catch {
//                print("Handle \(error) here")
//            }
//            
//            if let data = userData {
//                // Convert data to JSON here
//                do{
//                    let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
//                    print(json)
//                        
//                        //print(observerData.objectForKey("affiliation"))
//                        //print(observerData.objectForKey("display_name"))
//                        //print(observerData)
//                        if((json.objectForKey("affiliation")) != nil)
//                        {
//                            let observerAffiliationString = json.objectForKey("affiliation") as! String
//                            
//                            observerAffiliationsArray.addObject(observerAffiliationString)
//                        }
//                        else
//                        {
//                            observerAffiliationsArray.addObject("")
//                        }
//                        if((json.objectForKey("display_name")) != nil)
//                        {
//                            let observerDisplayNameString = json.objectForKey("display_name") as! String
//                            observerNamesArray.addObject(observerDisplayNameString)
//                        }
//                        else
//                        {
//                            observerNamesArray.addObject("")
//                        }
//                        
//                        
//                        
//                        
//                        //print(observerAffiliation)
//                        //print(observerDisplayName)
//                        if((json.objectForKey("avatar")) != nil)
//                        {
//                            let observerAvatar = json.objectForKey("avatar")
//                            print(observerAvatar)
//                            let observerAvatarUrl  = NSURL(string: observerAvatar as! String)
//                            if(UIApplication.sharedApplication().canOpenURL(observerAvatarUrl!) == true)
//                            {
//                                observerAvatarsArray.addObject(NSData(contentsOfURL: observerAvatarUrl!)!)
//                                observerAvatarsUrlArray.addObject(observerAvatar!)
//                            }
//                            else
//                            {
//                                let tempImageUrl = NSBundle.mainBundle().URLForResource("user", withExtension: "png")
//                                
//                                
//                                observerAvatarsArray.addObject(NSData(contentsOfURL: tempImageUrl!)!)
//                                observerAvatarsUrlArray.addObject((tempImageUrl?.absoluteString)!)
//                            }
//                            //let observerAvatarData = NSData(contentsOfURL: observerAvatarUrl!)
//                        }
//                        else
//                        {
//                            let tempImageUrl = NSBundle.mainBundle().URLForResource("user", withExtension: "png")
//                            
//                            observerAvatarsArray.addObject(NSData(contentsOfURL: tempImageUrl!)!)
//                            observerAvatarsUrlArray.addObject((tempImageUrl?.absoluteString)!)
//                           
//                    }
//
//                    
//                    
//                            
//                            
//                }catch let error as NSError {
//                    print("json error: \(error.localizedDescription)")
//                    let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }
//
//            }
            print(observationsCount)
        }
        print(observerAffiliationsArray)
        print(observerNamesArray)
        //print(observerAvatarsArray)
        
//        newObsAndDIViewtemp.view.frame = CGRectMake(0 ,self.view.frame.size.height-newObsAndDIViewtemp.view.frame.size.height-8 - 60, newObsAndDIViewtemp.view.frame.size.width, newObsAndDIViewtemp.view.frame.size.height)
//        self.view.addSubview(newObsAndDIViewtemp.view)
//        //self.view.bringSubviewToFront(newObsAndDIView.view)
//        newObsAndDIViewtemp.camButton.addTarget(self, action: #selector(ExploreViewController.openNewObsView), forControlEvents: .TouchUpInside)

    }
//    func openNewObsView()
//    {
//        print("gverver")
//        let cgVC = CameraAndGalleryViewController()
//        self.addChildViewController(cgVC)
//        cgVC.view.frame = CGRectMake(0, self.view.frame.size.height - cgVC.view.frame.size.height+68, cgVC.view.frame.size.width, cgVC.view.frame.size.height)
//        self.view.addSubview(cgVC.view)
//        UIView.animateWithDuration(0.3, animations: {
//            
//            cgVC.view.frame = CGRectMake(0, self.view.frame.size.height - cgVC.view.frame.size.height+68, cgVC.view.frame.size.width, cgVC.view.frame.size.height)
//            
//        }) { (isComplete) in
//            
//            cgVC.didMoveToParentViewController(self)
//            
//        }
//    }

    
    func dismissVC(){
        
        //self.navigationController!.dismissViewControllerAnimated(true, completion: {})
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        //self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        //print("abhi")
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return observerNamesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExploreCell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 1.0
        //        if let currentItem = beachDict[beachArray[indexPath.item]] {
        //            //Setting title for the images from description
        //            let title = currentItem.first?.description
        //            let index = title!.rangeOfString("-")?.startIndex
        //            if let value = index {
        //                cell.cellTitle.text = title?.substringFromIndex(value.successor())
        //            }else {
        //                cell.cellTitle.text = currentItem.first?.description
        //            }
        //
        //            //Fetch image from parse
        //            if let imageFile = currentItem.first?.imageFile {
        //                imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
        //                    if error == nil {
        //                        if let result = imageData {
        //                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //                                cell.currentImage = result
        //                            })
        //
        //                        }
        //                    }
        //                })
        //            }
        //        }
        
        let observationsImageUrlString = exploreObservationsImagesArray[indexPath.row] as! String
        let newimageURLString = observationsImageUrlString.stringByReplacingOccurrencesOfString("upload", withString: "upload/t_ios-thumbnail", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //observerImageUrlData = NSData(contentsOfURL: observerImageUrl)
        
        if let observationsImageUrl  = NSURL(string: newimageURLString)
        {
            //cell.exploreImageView.image = UIImage(data: observerImageUrlData)
            print(observationsImageUrl)
            cell.exploreImageView.kf_setImageWithURL(observationsImageUrl, placeholderImage: UIImage(named: "default-no-image.png"))
        }
        cell.bringSubviewToFront(cell.exploreProfileSubView)
        cell.exploreImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        //cell.exploreProfileIcon.image = UIImage(data: observerAvatarsArray[indexPath.row] as! NSData)
        cell.exploreProfileIcon.kf_setImageWithURL(NSURL.fileURLWithPath(observerAvatarsUrlArray[indexPath.row] as! String), placeholderImage: UIImage(named: "user.png"))
        
        if(observerNamesArray[indexPath.row] as! String != "")
        {
            cell.exploreProfileName.text = (observerNamesArray[indexPath.row] as! String)
        }
        else
        {
            cell.exploreProfileName.text = "No Display Name"
        }
        
        if(observerAffiliationsArray[indexPath.row] as! String != "")
        {
            cell.exploreDate.text = (observerAffiliationsArray[indexPath.row] as! String)
        }
        else
        {
            cell.exploreDate.text = "No Affiliation"
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath)
        let detailedObservationVC = DetailedObservationViewController()
        detailedObservationVC.observerImageUrl = observerAvatarsUrlArray[indexPath.row] as! String
        detailedObservationVC.observerDisplayName = observerNamesArray[indexPath.row] as! String;
        detailedObservationVC.observerAffiliation = observerAffiliationsArray[indexPath.row] as! String;
        detailedObservationVC.observationText = observationTextArray[indexPath.row] as! String;
        
        let observerImageUrlString = exploreObservationsImagesArray[indexPath.row] as! String
        let newimageURLString = observerImageUrlString.stringByReplacingOccurrencesOfString("upload", withString: "upload/t_ios-large", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        detailedObservationVC.observationImageUrl = newimageURLString
        //detailedObservationVC.observationsIdsfromExploreView = observerIdsfromMapView
        detailedObservationVC.observationId = observationIdsfromMapView[indexPath.row] as! String
        detailedObservationVC.observationCommentsArrayfromExploreView = commentsDictArrayfromMapView[indexPath.row] as! NSArray
        self.navigationController?.pushViewController(detailedObservationVC, animated: true)
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
