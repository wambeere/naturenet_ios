//
//  DetailedObservationViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 3/20/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit


class DetailedObservationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
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

    @IBOutlet weak var commentsTableView: UITableView!
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


    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentsTableViewCell
        
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
