//
//  UploadImageToCloudinary.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/20/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import UIKit
import Cloudinary

class UploadImageToCloudinary: UIViewController,CLUploaderDelegate {
    
    var Cloudinary:CLCloudinary!
    var gotUploaded = false
    
    var observationImage:UIImage?
    var selectedCloset:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        //uploadToCloudinary(observationImage!)
        
    }
    
    func uploadToCloudinary(image: UIImage) {
        
        let forUpload = UIImageJPEGRepresentation(image, 0.6)! as NSData
        Cloudinary = CLCloudinary(url: "cloudinary://893246586645466:8Liy-YcDCvHZpokYZ8z3cUxCtyk@university-of-colorado")
        //Cloudinary.config().setValue("university-of-colorado", forKey: "cloud_name")
        //Cloudinary.config().setValue("893246586645466", forKey: "api_key")
        //Cloudinary.config().setValue("8Liy-YcDCvHZpokYZ8z3cUxCtyk", forKey: "api_secret")
        
        let uploader = CLUploader(Cloudinary, delegate: self)
        uploader.upload(forUpload, options: nil, withCompletion:onCloudinaryCompletion, andProgress:onCloudinaryProgress)
        
        
    }
    
    func onCloudinaryCompletion(successResult:[NSObject : AnyObject]!, errorResult:String!, code:Int, idContext:AnyObject!) {
        let publicId = successResult["public_id"] as! String
        let url = successResult["url"] as? String
        print("now cloudinary uploaded, public id is: \(publicId) and \(url), ready for uploading media")
        // push media after cloudinary is finished
        //let params = ["link": publicId] as Dictionary<String, Any>
        //self.doPushNew(self.apiService!, params: params)
        if(url != "")
        {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(url, forKey: "observationImageUrl")
        }
    }
    
    func onCloudinaryProgress(bytesWritten:Int, totalBytesWritten:Int, totalBytesExpectedToWrite:Int, idContext:AnyObject!) {
        //do any progress update you may need
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) as Float
        //self.updateProgressDelegate?.onUpdateProgress(progress)
        print("uploading to cloudinary... wait! \(progress * 100)%")
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
