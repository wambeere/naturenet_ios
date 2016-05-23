//
//  NewObservationDetailsViewController.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/13/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit

class NewObservationDetailsViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var isDescription : Bool = false

    @IBOutlet var obsProjectsTableView: UITableView!
    @IBOutlet var obsDescriptionTextView: UITextView!
    
    let newObsVC = NewObsViewController()
    
    var project : String = ""
    
    var projItems: [String] = ["Red Mountain", "Native or Not?","How many Mallards?", "Heron Spotting","Who's Who?", "Tracks"]
    var projIcons: [String] = ["RedMountain.png", "Native.png","Mallard.png", "Heron.png","Who.png", "Tracks.png"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="Observation Details"
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 48.0/255.0, green: 204.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "double_down.png"), style: .Plain, target: self, action: #selector(NewObservationDetailsViewController.dismissVC))
        navigationItem.leftBarButtonItem = barButtonItem
        
        if(isDescription == true)
        {
            self.view.addSubview(obsDescriptionTextView)
        }
        else
        {
            self.view.addSubview(obsProjectsTableView)
            obsProjectsTableView.delegate = self
            obsProjectsTableView.dataSource = self
            obsProjectsTableView.separatorColor = UIColor.clearColor()
            obsProjectsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            obsProjectsTableView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        }
        
        
        
        self.view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    func dismissVC(){
        
        //self.navigationController!.dismissViewControllerAnimated(true, completion: {})
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            
            let userDefaults = NSUserDefaults.standardUserDefaults()

            if(self.isDescription == true)
            {
                userDefaults.setValue(self.obsDescriptionTextView.text, forKey: "ObservationDescription")
            }
            else
            {
                userDefaults.setValue(self.project, forKey: "Project")
            }
        
        })
        //self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        //print("abhi")
        
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.projItems[indexPath.row]
        cell.imageView?.image = UIImage(named: projIcons[indexPath.row])
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        
//        cell.frame = CGRectMake(8,cell.frame.size.height+3,self.view.frame.size.width-16,cell.frame.size.height)
//        
        let additionalSeparator = UIView()
        additionalSeparator.frame = CGRectMake(0,cell.frame.size.height-3,self.view.frame.size.width,3)
        additionalSeparator.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        cell.addSubview(additionalSeparator)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.project = projItems[indexPath.row]
        
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
