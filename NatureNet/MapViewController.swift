//
//  MapViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/17/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate{
    
    @IBOutlet var mapAnnotationClickView: UIView!
    @IBOutlet weak var exploreView: UIView!
    @IBOutlet weak var mapAnnotationClickSubView: UIView!
    let locationManager = CLLocationManager()
    @IBOutlet var mapTypeView: UIView!
    
    @IBOutlet weak var observationImageView: UIImageView!
    @IBOutlet weak var observerDisplayName: UILabel!
    @IBOutlet weak var observerAffiliation: UILabel!
    @IBOutlet weak var observerAvatarImageView: UIImageView!
    @IBOutlet weak var observationTextLabel: UILabel!
    var count = 0
    var observationImagesArray : NSMutableArray = []
    var observationTextArray : NSMutableArray = []
    var observerIds : NSMutableArray = []
    
    var observerAvatarUrlString : String = ""
    var observervationUrlString : String = ""
    
    let mapView = MKMapView(frame: UIScreen.mainScreen().bounds)
    var tempAnnotationView : MKAnnotationView!
    
    var likesCount: Int = 0
    var likesCountArray: NSMutableArray = []
    
    var commentsDictArray : NSMutableArray = []
    var commentsDicttoDetailVC : NSDictionary = [:]
    var commentsCountArray: NSMutableArray = []
    
    let newObsAndDIView = NewObsAndDIViewController()
    
    let cgVC = CameraAndGalleryViewController()
    let diAndCVC = DesignIdeasAndChallengesViewController()
    
    var obsevationIds : NSMutableArray = []
    
    var obsevationId : String = ""
    
    var locValue = CLLocationCoordinate2D()
    
    var observationProjectNames : NSMutableArray = []
    
    var ProjectName : String = ""
    
    var observationCommentsArray : NSArray = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(exploreView);
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 290
           
            let barButtonItem = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            navigationItem.leftBarButtonItem = barButtonItem
            
        }
        
        let rightbarButtonItem = UIBarButtonItem(image: UIImage(named: "more.png"), style: .Plain, target: self, action: #selector(MapViewController.mapTypes))
        navigationItem.rightBarButtonItem = rightbarButtonItem
        
        
        self.navigationItem.title="NatureNet"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        exploreView.backgroundColor=UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        exploreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MapViewController.tappedView)))
        exploreView.userInteractionEnabled = true
        
        activityIndicator.hidden = true

        mapView.frame = CGRectMake(0 , 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-self.exploreView.frame.height)
        mapView.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MapViewController.mapViewTapped)))
        mapView.userInteractionEnabled = true
        //mapView.showsUserLocation = true
        mapView.mapType = .Satellite
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else
        {
            //if (mapView.userLocation.location == nil)
            let userDefaults = NSUserDefaults()
            print(userDefaults.objectForKey("userAffiliation"))
            if let userAffiliation = userDefaults.objectForKey("userAffiliation"){
                
                let myRootRef = Firebase(url:"https://naturenet-staging.firebaseio.com/sites/\(userAffiliation)")
                myRootRef.observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot.value["l"])
                    let siteLocationArray = snapshot.value["l"] as! NSArray
                    print(siteLocationArray[0])
                    print(siteLocationArray[1])
                    
                    var locCoord = CLLocationCoordinate2D()
                    locCoord.latitude = siteLocationArray[0] as! Double
                    locCoord.longitude = siteLocationArray[1] as! Double
                    
                    self.setMapViewCoordinates(locCoord)
                    
                    
                    }, withCancelBlock: { error in
                        print(error.description)
                })

                
            }
            
        }
        
        
        self.view.addSubview(mapView)
        
        mapAnnotationClickView.frame = CGRectMake(0,UIScreen.mainScreen().bounds.size.height-mapAnnotationClickView.frame.size.height, mapAnnotationClickView.frame.size.width, mapAnnotationClickView.frame.size.height)
        mapAnnotationClickSubView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MapViewController.mapAnnotationClickSubViewtapped)))
        mapAnnotationClickSubView.userInteractionEnabled = true
        
       
        
                
        //declare this property where it won't go out of scope relative to your listener
        var reachability: Reachability?
        
        //declare this inside of viewWillAppear
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapViewController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        if(UIScreen.mainScreen().nativeBounds.height <= 1136)
        {
            newObsAndDIView.view.frame = CGRectMake(0 ,UIScreen.mainScreen().bounds.size.height-newObsAndDIView.view.frame.size.height-8 - 60, UIScreen.mainScreen().bounds.size.width, newObsAndDIView.view.frame.size.height)
            
            newObsAndDIView.designIdeaButton.frame = CGRectMake(newObsAndDIView.designIdeaButton.frame.origin.x - newObsAndDIView.designIdeaButton.frame.size.width, newObsAndDIView.designIdeaButton.frame.origin.y, newObsAndDIView.designIdeaButton.frame.size.width, newObsAndDIView.designIdeaButton.frame.size.height)
        }
        else
        {
            newObsAndDIView.view.frame = CGRectMake(0 ,UIScreen.mainScreen().bounds.size.height-newObsAndDIView.view.frame.size.height-8 - 60, UIScreen.mainScreen().bounds.size.width, newObsAndDIView.view.frame.size.height)
            
        }
        self.view.addSubview(newObsAndDIView.view)
        //self.view.bringSubviewToFront(newObsAndDIView.view)
        newObsAndDIView.camButton.addTarget(self, action: #selector(MapViewController.openNewObsView), forControlEvents: .TouchUpInside)
        
        newObsAndDIView.designIdeaButton.addTarget(self, action: #selector(MapViewController.openNewDesignView), forControlEvents: .TouchUpInside)
        
        
        
        
    }
    
    func setMapViewCoordinates(locationCoord: CLLocationCoordinate2D)
    {
        let regionRadius: CLLocationDistance = 600
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(locationCoord,
                                                                      regionRadius * 4.0, regionRadius * 4.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
//        if let location = locations.first {
//            // implement logic upon location change and stop updating location until it is subsequently updated
        locationManager.stopUpdatingLocation()
        locValue = locations.last!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.setMapViewCoordinates(locValue)
            
        
//        }
    }
    func openNewObsView()
    {
        //print("gverver")
        self.addChildViewController(cgVC)
        
        cgVC.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - cgVC.view.frame.size.height+68, cgVC.view.frame.size.width, cgVC.view.frame.size.height)
        self.view.addSubview(cgVC.view)
        cgVC.closeButton.hidden = true
        UIView.animateWithDuration(0.3, animations: {
        
            self.cgVC.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - self.cgVC.view.frame.size.height+68, self.cgVC.view.frame.size.width, self.cgVC.view.frame.size.height)
        
        }) { (isComplete) in
        
            self.cgVC.didMoveToParentViewController(self)
                    
        }
    }
    func openNewDesignView()
    {
        //print("gverver")
        self.addChildViewController(diAndCVC)
        diAndCVC.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - diAndCVC.view.frame.size.height+68, diAndCVC.view.frame.size.width, diAndCVC.view.frame.size.height)
        diAndCVC.closeButton.hidden = true
        
        self.view.addSubview(diAndCVC.view)
        UIView.animateWithDuration(0.3, animations: {
            
            self.diAndCVC.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - self.diAndCVC.view.frame.size.height+68, self.diAndCVC.view.frame.size.width, self.diAndCVC.view.frame.size.height)
            
        }) { (isComplete) in
            
            self.diAndCVC.didMoveToParentViewController(self)
            
        }
    }

    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            //                if reachability.isReachableViaWiFi() {
            //                    print("Reachable via WiFi")
            //                } else {
            //                    print("Reachable via Cellular")
            //                }
            dispatch_async(dispatch_get_main_queue(), {
                // code here
                self.getObservations()
            })
            
        } else {
            print("Network not reachable")
            let alert = UIAlertController(title: "Alert", message:"Please Check your Internet Connection" ,preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func getObservations()
    {
        
        let observationUrl = NSURL(string: OBSERVATIONS_URL)
        //let observationUrl = NSURL(string: "https://naturenet.firebaseio.com/observations/-KFRnObtgXwJXwnKF0yj.json")
        
        var userData:NSData? = nil
        do {
            userData = try NSData(contentsOfURL: observationUrl!, options: NSDataReadingOptions())
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
                    

                    
                    print(json.allValues[i])
                    
                        let observationData = json.allValues[i] as! NSDictionary
                  
                        
                        if(observationData.objectForKey("comments") != nil)
                        {
                            let tempcomments = observationData.objectForKey("comments") as! NSDictionary
                            print(tempcomments)
                            let commentsKeysArray = tempcomments.allKeys as NSArray
                            commentsDictArray.addObject(commentsKeysArray)
                            
                            print(commentsDictArray)
                            
                            print(observationData.objectForKey("id"))
                            
                            commentsCountArray.addObject("\(commentsKeysArray.count)")
                        }
                        else
                        {
                            let tempcomments = NSArray()
                            commentsDictArray.addObject(tempcomments)
                            
                            commentsCountArray.addObject("0")
                        }
                    
                    if(observationData.objectForKey("likes") != nil)
                    {
                        let likesDictionary = observationData.objectForKey("likes") as! NSDictionary
                        print(likesDictionary.allValues)
                        
                        let likesArray = likesDictionary.allValues as NSArray
                        print(likesArray)
                        
                        
                        for l in 0 ..< likesArray.count
                        {
                            if(likesArray[l] as! NSObject == 1)
                            {
                                likesCount += 1
                            }
                        }
                        print(likesCount)
                        
                        
                        likesCountArray.addObject("\(likesCount)")
                        
                        
                    }
                    else
                    {
                        likesCountArray.addObject("0")
                    }

                    
                        var latAndLongs: NSArray = []
                        var observationImageAndText: NSDictionary = [:]
                    
                        if(observationData.objectForKey("l") != nil)
                        {
                            latAndLongs = observationData.objectForKey("l") as! NSArray
                            //print(latAndLongs[0])
                            //print(latAndLongs[1])
                            print(latAndLongs)
                            let annotationLatAndLong = CLLocation(latitude: latAndLongs[0].doubleValue, longitude: latAndLongs[1].doubleValue)
                            
                            mapViewCoordinate(annotationLatAndLong, tagForAnnotation: i)
                            
                        }
                        else{
                            
                            let tempArr = NSArray()
                            latAndLongs = tempArr
                        }
                        if(observationData.objectForKey("data") != nil)
                        {
                            observationImageAndText = observationData.objectForKey("data") as! NSDictionary
                        }
                        else
                        {
                            let tempDic = NSDictionary()
                            observationImageAndText = tempDic
                        }
                    
                    if(observationData.objectForKey("activity_location") != nil)
                    {
                        let actloc = observationData.objectForKey("activity_location") as! String
                        print("*****"+actloc)
                    
                        let geoActivitiesUrl = NSURL(string: FIREBASE_URL + "geo/activities/\(actloc).json")
                    
                        
                        var geoActivitiesData:NSData? = nil
                        do {
                            geoActivitiesData = try NSData(contentsOfURL: geoActivitiesUrl!, options: NSDataReadingOptions())
                        //print(userData)
                        }
                        catch {
                            print("Handle \(error) here")
                        }
                    
                        if let geodata = geoActivitiesData {
                            // Convert data to JSON here
                            do{
                                let geojson: NSDictionary = try NSJSONSerialization.JSONObjectWithData(geodata, options: NSJSONReadingOptions()) as! NSDictionary
                            
                                let geoActivity = geojson.objectForKey("activity") as! String
                                //let geoActivityId = geojson.objectForKey("id") as! String
                                
                                print("((((("+geoActivity)
                                
                               
                                    
                                    let activitiesUrl = NSURL(string: FIREBASE_URL + "activities.json")
                                    
                                    var activitiesData:NSData? = nil
                                    do {
                                        activitiesData = try NSData(contentsOfURL: activitiesUrl!, options: NSDataReadingOptions())
                                        //print(userData)
                                    }
                                    catch {
                                        print("Handle \(error) here")
                                    }
                                    
                                    if let data = activitiesData {
                                        // Convert data to JSON here
                                        do{
                                            let activitiesJson: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! NSDictionary
                                            
                                            print(activitiesJson.allKeys)
                                            
                                            for j in 0 ..< activitiesJson.count
                                            {
                                                
                                                let activity = activitiesJson.allKeys[j] as! String
                                                let activityDictionary = activitiesJson.objectForKey(activity) as! NSDictionary
                                                //print(activityDictionary.objectForKey("name"))
                                                if(activityDictionary.objectForKey("name") != nil && actloc != "")
                                                {
                                                    //print(geoActivity)
                                                    //print(activity)
                                                    if(activity == geoActivity)
                                                    {
                                                        observationProjectNames.addObject(activityDictionary.objectForKey("name")!)
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
                                    }}
                                    
                                catch let error as NSError {
                                print("json error: \(error.localizedDescription)")
                                let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        

                        }
                    
                    }
                    
                    
                    print(observationProjectNames)
                        
                        
                        
                        
                        //                    if(observationData.objectForKey("comments") != nil)
                        //                    {
                        //                        let tempcomments = observationData.objectForKey("comments") as! NSDictionary
                        //                        print(tempcomments)
                        //                        commentsDictArray.addObject(tempcomments)
                        //
                        //                        print(commentsDictArray)
                        //                    }
                        //                    else
                        //                    {
                        //                        let tempcomments = NSDictionary()
                        //                        commentsDictArray.addObject(tempcomments)
                        //                    }
                        
                        
                        if(observationData.objectForKey("id") != nil)
                        {
                            let obsId = observationData.objectForKey("id") as! String
                            print(obsId)
                            obsevationIds.addObject(obsId)
                        }
                        else
                        {
                            obsevationIds.addObject("")
                        }
                        
                        
                        //
                        //                    commentsDictionaryArray.addObject(tempcomments)
                        //
                        //                    for j in 0 ..< tempcomments.count
                        //                    {
                        //                        let comments = tempcomments.allValues[j] as! NSDictionary
                        //                        print(comments)
                        //                    }
                        
                        if(observationImageAndText["image"] != nil)
                        {
                            
                            print(observationImageAndText["image"])
                            let imageURLString = observationImageAndText["image"] as! String
                            //let aString: String = "This is my string"
                            let newimageURLString = imageURLString.stringByReplacingOccurrencesOfString("upload", withString: "upload/t_ios-thumbnail", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            observationImagesArray.addObject(newimageURLString)
                        }
                        else
                        {
                            observationImagesArray.addObject("")
                        }
                        if(observationImageAndText["text"] != nil)
                        {
                            //print(observationImageAndText["text"])
                            observationTextArray.addObject(observationImageAndText["text"]!)
                        }
                        else
                        {
                            observationTextArray.addObject("")
                        }
                        
                        if(observationData.objectForKey("observer") != nil)
                        {
                            let observerId = observationData.objectForKey("observer") as! String
                            //print(observerId)
                            observerIds.addObject(observerId)
                        }
                        else
                        {
                            observerIds.addObject("")
                        }
                    
                    

                    
              
                }

                //print(observationImagesArray)

            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Alert", message:error.localizedDescription ,preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }

            
        }

    }
    func mapTypes()
    {
        mapTypeView.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - mapTypeView.frame.size.width-mapTypeView.frame.size.width/12,64, mapTypeView.frame.size.width, mapTypeView.frame.size.height)
        //mapTypeView.layer.cornerRadius = 8.0
        //mapTypeView.clipsToBounds = true
        if(count%2 == 0)
        {
            self.view.addSubview(mapTypeView)
        }
        else
        {
            mapTypeView.removeFromSuperview()
        }
        count += 1
        
    }
    @IBAction func mapTypeStandard(sender: UIButton) {
        
        mapView.mapType = .Standard
        
    }
    @IBAction func mapTypeSatellite(sender: UIButton) {
        
        mapView.mapType = .Satellite
        
    }
    func mapViewTapped()
    {
        if let mapTypeViewWithTag = self.view.viewWithTag(9) {
            mapTypeViewWithTag.removeFromSuperview()
            count += 1
        }
        if let exploreViewWithTag = self.view.viewWithTag(8) {
            exploreViewWithTag.removeFromSuperview()
            
        }
        newObsAndDIView.view.frame = CGRectMake(0 ,UIScreen.mainScreen().bounds.size.height-newObsAndDIView.view.frame.size.height-8 - 60, newObsAndDIView.view.frame.size.width, newObsAndDIView.view.frame.size.height)
        cgVC.view.removeFromSuperview()
        cgVC.removeFromParentViewController()
        diAndCVC.view.removeFromSuperview()
        diAndCVC.removeFromParentViewController()
        
    }
    
    func mapViewCoordinate(annotationLocation: CLLocation, tagForAnnotation : Int)
    {
        let initialLocation = CLLocation(latitude: annotationLocation.coordinate.latitude, longitude: annotationLocation.coordinate.longitude)
        
        self.setMapViewCoordinates(locValue)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(initialLocation.coordinate.latitude, initialLocation.coordinate.longitude)
        annotation.title = String(tagForAnnotation)
        //annotation.subtitle = "This is the location !!!"
        mapView.addAnnotation(annotation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedView(){
        
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        exploreView.backgroundColor=UIColor.lightGrayColor()
        exploreView.userInteractionEnabled = false
        let eVC = ExploreViewController() //change this to your class name
        eVC.exploreObservationsImagesArray = observationImagesArray
        eVC.observerIdsfromMapView = observerIds
        eVC.observationTextArray = observationTextArray
        eVC.commentsDictArrayfromMapView = commentsDictArray
        eVC.observationIdsfromMapView = obsevationIds
        let exploreNavVC = UINavigationController()
        exploreNavVC.viewControllers = [eVC]
        self.presentViewController(exploreNavVC, animated: true, completion: nil)
        //activityIndicator.stopAnimating()
        
    }
    override func viewWillAppear(animated: Bool) {
        
        exploreView.backgroundColor=UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        exploreView.userInteractionEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        //let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        let str :String? = annotation.title!
        let tag: Int? = Int(str!)
    
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MyPin")
            annotationView!.canShowCallout = false
            //annotationView!.image = UIImage(named: "marker.png")
            annotationView!.contentMode = UIViewContentMode.ScaleAspectFit
            annotationView?.tag = tag!
            //annotationView!.rightCalloutAccessoryView = detailButton
            
            let annotationImageView = UIImageView(image: UIImage(named:"marker.png"))
            
            var annotationImageRect = annotationImageView.frame as CGRect
            annotationImageRect.size.height = 44
            annotationImageRect.size.width = 44
            
            annotationImageView.frame = annotationImageRect
            annotationView?.frame = annotationImageRect
            
            annotationView?.addSubview(annotationImageView)
            
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        
        return annotationView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if let annotation = view.annotation as? MKPointAnnotation {
//            mapView.removeAnnotation(annotation)
//        }
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        print("annotation")
        //view.hidden=true
//        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
//            view.frame = CGRectMake(view.frame.origin.x,view.frame.origin.y, view.frame.width * 1.5, self.view.frame.height * 0.1)
        UIView.animateWithDuration(0.3, animations: {
           
            self.newObsAndDIView.view.frame = CGRectMake(0 , self.mapAnnotationClickView.frame.origin.y - self.newObsAndDIView.view.frame.size.height-8, self.newObsAndDIView.view.frame.width, self.newObsAndDIView.view.frame.height)
        
            self.view.addSubview(self.mapAnnotationClickView)
            
        })
        likesCountLabel.text = "\(likesCountArray[view.tag])"
        commentsCountLabel.text = "\(commentsCountArray[view.tag])"
        
        obsevationId = obsevationIds[view.tag] as! String
        ProjectName = observationProjectNames[view.tag] as! String
//            }, completion: nil)
//        self.mapViewCoordinate()
        print(commentsDictArray.objectAtIndex(view.tag))
        //commentsDicttoDetailVC = commentsDictArray.objectAtIndex(view.tag)  as! NSDictionary
        observationCommentsArray = commentsDictArray.objectAtIndex(view.tag)  as! NSArray
        
        observationTextLabel.text = (observationTextArray[view.tag] as! String)
        
        if let url  = NSURL(string: observationImagesArray[view.tag] as! String),
            data = NSData(contentsOfURL: url)
        {
            observationImageView.image = UIImage(data: data)
            observervationUrlString = observationImagesArray[view.tag] as! String
        }
        
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                //                if reachability.isReachableViaWiFi() {
                //                    print("Reachable via WiFi")
                //                } else {
                //                    print("Reachable via Cellular")
                //                }
                
           
        let url = NSURL(string: USERS_URL+"\(self.observerIds[view.tag]).json")
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
                        self.observerAffiliation.text = observerAffiliationString
                        //observerAffiliationsArray.addObject(observerAffiliationString)
                        print(observerAffiliationString)
                    }
                    else
                    {
                        self.observerAffiliation.text = ""
                    }
                    
                    if((json.objectForKey("display_name")) != nil)
                    {
                        let observerDisplayNameString = json.objectForKey("display_name") as! String
                        self.observerDisplayName.text = observerDisplayNameString
                        //observerNamesArray.addObject(observerDisplayNameString)
                    }
                    else
                    {
                        self.observerDisplayName.text = ""
                    }
                    
                    //print(observerAffiliation)
                    //print(observerDisplayName)
                    if((json.objectForKey("avatar")) != nil)
                    {
                        let observerAvatar = json.objectForKey("avatar")
                        if let observerAvatarUrl  = NSURL(string: observerAvatar as! String),
                            observerAvatarData = NSData(contentsOfURL: observerAvatarUrl)
                        {
                            self.observerAvatarImageView.image = UIImage(data: observerAvatarData)
                            //observerAvatarsArray.addObject(observerAvatar!)
                            self.observerAvatarUrlString = observerAvatar as! String
                        }
                    }
                    else
                    {
                        self.observerAvatarImageView.image = UIImage(named:"user.png")
                        //observerAvatarsArray.addObject(NSBundle.mainBundle().URLForResource("user", withExtension: "png")!)
                        
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
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                
                let alert = UIAlertController(title: "Alert", message:"Please Check your Internet Connection" ,preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func mapAnnotationClickSubViewtapped(){
        
        let detailedObservationVC = DetailedObservationViewController()
        detailedObservationVC.observerImageUrl = observerAvatarUrlString
        detailedObservationVC.observerDisplayName = observerDisplayName.text!
        detailedObservationVC.observerAffiliation = observerAffiliation.text!
        detailedObservationVC.observationImageUrl = observervationUrlString
        detailedObservationVC.observationText = observationTextLabel.text!
        detailedObservationVC.observationCommentsArrayfromExploreView = observationCommentsArray
        detailedObservationVC.observationId = obsevationId
        detailedObservationVC.pageTitle = ProjectName
        self.navigationController?.pushViewController(detailedObservationVC, animated: true)
        
    }
    
    @IBAction func shareButtonClicked(sender: UIButton) {
        
        displayShareSheet("NatureNet")
        
    }
    func displayShareSheet(shareContent:String) {
        // let activityItem: [AnyObject] = [self.imageView.image as! AnyObject]
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    @IBAction func likesButtonClicked(sender: UIButton) {
        
        mapAnnotationClickSubViewtapped()
        
    }
    @IBAction func commentsButtonClicked(sender: UIButton) {
        
        mapAnnotationClickSubViewtapped()
        
    }
        
        
}
