//
//  Observation.swift
//  NatureNet
//
//  Created by James B on 6/29/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import Foundation
import Cloudinary
import Firebase

//TODO upload function to upload self

class ObservationForLater : NSObject, NSCoding, CLUploaderDelegate {
    
    var projectKey : String
    var observationDescription : String
    var imageData = NSData()
    var imageURL : String
    var observerID : String
    var longitude : Double
    var latitude : Double
    
    //should be replaced with more secure storage (ie keychain)
    var email : String
    var password : String
    
    var imageUploaded : Bool
    
    init (projectKey:String, observationDescription:String, imageData:NSData, imageURL:String = "", observerID:String, longitude:Double, latitude:Double, email:String, password:String, imageUploaded:Bool)
    {
        self.projectKey = projectKey
        self.observationDescription = observationDescription
        self.imageData = imageData
        self.imageURL = imageURL
        self.observerID = observerID
        self.longitude = longitude
        self.latitude = latitude
        self.email = email
        self.password = password
        self.imageUploaded = imageUploaded

    }
    
    required init(coder decoder: NSCoder) {
        
        self.projectKey = decoder.decodeObjectForKey("projectKey") as! String
        self.observationDescription = decoder.decodeObjectForKey("observationDescription") as! String
        self.imageData = decoder.decodeObjectForKey("imageData") as! NSData
        self.imageURL = decoder.decodeObjectForKey("imageURL") as! String
        self.observerID = decoder.decodeObjectForKey("observerID") as! String
        self.longitude = decoder.decodeDoubleForKey("longitude")
        self.latitude = decoder.decodeDoubleForKey("latitude")
        self.email = decoder.decodeObjectForKey("email") as! String
        self.password = decoder.decodeObjectForKey("password") as! String
        self.imageUploaded = decoder.decodeBoolForKey("imageUploaded")
        
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.projectKey, forKey: "projectKey")
        coder.encodeObject(self.observationDescription, forKey: "observationDescription")
        coder.encodeObject(self.imageData, forKey: "imageData")
        coder.encodeObject(self.imageURL, forKey: "imageURL")
        coder.encodeObject(self.observerID, forKey: "observerID")
        coder.encodeDouble(self.longitude, forKey: "longitude")
        coder.encodeDouble(self.latitude, forKey: "latitude")
        coder.encodeObject(self.email, forKey: "email")
        coder.encodeObject(self.password, forKey: "password")
        coder.encodeBool(self.imageUploaded, forKey: "imageUploaded")
        
    }
    
    func upload(){
        
        let refUser = FIRAuth.auth() //Firebase(url: FIREBASE_URL)
        refUser!.signInWithEmail(email, password: password,
             completion: { authData, error in
                if error != nil {
                    
                    print("\(error)")
                    if(self.email == "")
                    {
                        //remove for no login info
                        self.removeSelfFromUserDefaults()
                    }
                    else
                    {
                        //incorrect password and user not found respectively
                        if(error?.code == 17009 || error?.code == 17011) {
                            self.removeSelfFromUserDefaults()
                        }
                        
                        //otherwise we can assume that the internet went out again
                    }
                }
                else
                {
                    if !self.imageUploaded {
                        //this function will call the firebase post function when it is done
                        self.uploadImage()
                    } else {
                        self.postToFirebase()
                    }
                }
        })
    }
    
    
    private func uploadImage() {
        
        var Cloudinary:CLCloudinary!
        
        let infoPath = NSBundle.mainBundle().pathForResource("Info.plist", ofType: nil)!
        let info = NSDictionary(contentsOfFile: infoPath)!
        //print(info.objectForKey("CloudinaryAccessUrl"))
        
        Cloudinary = CLCloudinary(url: info.objectForKey("CloudinaryAccessUrl") as! String)
        let uploader = CLUploader(Cloudinary, delegate: self)
        
        
        uploader.upload(imageData, options: nil, withCompletion:onCloudinaryCompletion, andProgress:onCloudinaryProgress)
        
    }
    
    func onCloudinaryCompletion(successResult:[NSObject : AnyObject]!, errorResult:String!, code:Int, idContext:AnyObject!) {
        if(errorResult == nil) {
            let publicId = successResult["public_id"] as! String
            let url = successResult["url"] as? String
            print("now cloudinary uploaded, public id is: \(publicId) and \(url), ready for uploading media")
            // push media after cloudinary is finished
            //let params = ["link": publicId] as Dictionary<String, Any>
            //self.doPushNew(self.apiService!, params: params)
            if(url != "")
            {
                imageURL = url!
                imageUploaded = true

                postToFirebase()
            }
            
        }
        else {
            print(errorResult.localizedLowercaseString)
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
    
    private func postToFirebase() {
     
        let ref = FIRDatabase.database().referenceWithPath("observations")
        print(ref.childByAutoId())
        let autoID = ref.childByAutoId()
        
        if(self.projectKey == ""){
            
            self.projectKey = "-ACES_g38"
        }
        
        print(self.projectKey)
        //    if(userDefaults.objectForKey("progress") as? String == "100.0")
        //    {
        let obsDetails = ["data":["image": imageURL as AnyObject, "text" : self.observationDescription as AnyObject],"l":["0": self.latitude as AnyObject, "1" : self.longitude as AnyObject],"id": autoID.key,"activity_location": self.projectKey,"observer":self.observerID, "created_at": FIRServerValue.timestamp(),"updated_at": FIRServerValue.timestamp()]
        autoID.setValue(obsDetails)
        
        print(autoID)
        
        removeSelfFromUserDefaults()
        
    }
    
    func removeSelfFromUserDefaults() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var laterData = (userDefaults.objectForKey("observationsForLater") as? NSData)!
        
        var laterArray = NSKeyedUnarchiver.unarchiveObjectWithData(laterData) as? [ObservationForLater]
        
        if laterArray != nil {
            
            for i in 0..<laterArray!.count {
                if laterArray![i].equals(self) {
                    laterArray?.removeAtIndex(i)
                }
            }
            
            laterData = NSKeyedArchiver.archivedDataWithRootObject(laterArray!)
        }
        
        userDefaults.setObject(laterData, forKey: "observationsForLater")
        
    }
    
    func equals(obs: ObservationForLater) -> Bool
    {
        return
            self.projectKey == obs.projectKey &&
            self.observationDescription == obs.observationDescription &&
            self.imageData == obs.imageData &&
            self.observerID == obs.observerID &&
            self.longitude == obs.longitude &&
            self.latitude == obs.latitude &&
            self.email == obs.email &&
            self.password == obs.password
    }
    
    
}