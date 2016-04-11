//
//  ExploreViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/19/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var observerIdsfromMapView : NSMutableArray = []
    
    var exploreObservationsImagesArray : NSArray!
    
    var observerAvatarsArray : NSMutableArray = []
    var observerAvatarsUrlArray : NSMutableArray = []
    var observerNamesArray : NSMutableArray = []
    var observerAffiliationsArray : NSMutableArray = []
    var observationTextArray : NSMutableArray = []

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
        layout.itemSize = CGSize(width: 110, height: 110)
        
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
        
        for i in 0 ..< observerIdsfromMapView.count
        {
            let url = NSURL(string: USERS_URL+"\(observerIdsfromMapView[i]).json")
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
                    if let observerData = json["public"] as? NSDictionary {
                        
                        //print(observerData.objectForKey("affiliation"))
                        //print(observerData.objectForKey("display_name"))
                        print(observerData)
                        if((observerData.objectForKey("affiliation")) != nil)
                        {
                            let observerAffiliationString = observerData.objectForKey("affiliation") as! String
                            
                            observerAffiliationsArray.addObject(observerAffiliationString)
                        }
                        else
                        {
                            observerAffiliationsArray.addObject("")
                        }
                        if((observerData.objectForKey("display_name")) != nil)
                        {
                            let observerDisplayNameString = observerData.objectForKey("display_name") as! String
                            observerNamesArray.addObject(observerDisplayNameString)
                        }
                        else
                        {
                            observerNamesArray.addObject("")
                        }
                        
                        
                        
                        
                        //print(observerAffiliation)
                        //print(observerDisplayName)
                        if((observerData.objectForKey("avatar")) != nil)
                        {
                            let observerAvatar = observerData.objectForKey("avatar")
                            if let observerAvatarUrl  = NSURL(string: observerAvatar as! String),
                                observerAvatarData = NSData(contentsOfURL: observerAvatarUrl)
                            {
                                observerAvatarsArray.addObject(observerAvatarData)
                                observerAvatarsUrlArray.addObject(observerAvatar!)
                            }
                        }
                        else
                        {
                            
                            if let tempImageUrl = NSBundle.mainBundle().URLForResource("user", withExtension: "png"),
                                observerAvatarData = NSData(contentsOfURL: tempImageUrl)
                            {
                                observerAvatarsArray.addObject(observerAvatarData)
                                observerAvatarsUrlArray.addObject(tempImageUrl)
                                
                            }
                        }
                        
                    }
                    
                }catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }

        }
        print(observerAffiliationsArray)
        print(observerNamesArray)
        print(observerAvatarsArray)

    }
    
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
        return observerIdsfromMapView.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExploreCell", forIndexPath: indexPath) as! ExploreCollectionViewCell
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
        
        
        
        if let observerImageUrl  = NSURL(string: exploreObservationsImagesArray[indexPath.row] as! String),
            observerImageUrlData = NSData(contentsOfURL: observerImageUrl)
        {
            cell.exploreImageView.image = UIImage(data: observerImageUrlData)
        }
        cell.bringSubviewToFront(cell.exploreProfileSubView)
        cell.exploreImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        cell.exploreProfileIcon.image = UIImage(data: observerAvatarsArray[indexPath.row] as! NSData)
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
        detailedObservationVC.observationImageUrl = exploreObservationsImagesArray[indexPath.row] as! String;
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
