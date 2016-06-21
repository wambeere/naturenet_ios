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
        
        Cloudinary = CLCloudinary(url: "cloudinary://893246586645466:8Liy-YcDCvHZpokYZ8z3cUxCtyk@university-of-colorado")
        let uploader = CLUploader(Cloudinary, delegate: self)
        
        let maxSide = CGFloat(1920)
        let originalWidth = image.size.width
        let originalHeight = image.size.height
        var forUpload = NSData()
        

        if(originalWidth > maxSide || originalHeight > maxSide)
        {
            //one of the two has to be 1920, so this is an easy way to give initial values
            var newWidth = maxSide
            var newHeight = maxSide
            
            if(originalWidth >= originalHeight)
            {
                let scaleRatio = originalWidth / maxSide
                newHeight = originalHeight / scaleRatio
            } else {
                let scaleRatio = originalHeight / maxSide
                newWidth = originalWidth / scaleRatio
            }
            
            let rect = CGRectMake(0.0, 0.0, newWidth, newHeight)
            UIGraphicsBeginImageContext(rect.size)
            image.drawInRect(rect)
            let smallerImage = UIGraphicsGetImageFromCurrentImageContext()
            forUpload = UIImageJPEGRepresentation(smallerImage, 0.6)! as NSData
            
        
        } else {
            //less compression on the already smaller images
            forUpload = UIImageJPEGRepresentation(image, 0.7)! as NSData
        }
        
        uploader.upload(forUpload, options: nil, withCompletion:onCloudinaryCompletion, andProgress:onCloudinaryProgress)
        
        
        
        
        //Cloudinary.config().setValue("university-of-colorado", forKey: "cloud_name")
        //Cloudinary.config().setValue("893246586645466", forKey: "api_key")
        //Cloudinary.config().setValue("8Liy-YcDCvHZpokYZ8z3cUxCtyk", forKey: "api_secret")
        
        
        
        
        
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
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue("\(progress * 100)", forKey: "progress")
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
