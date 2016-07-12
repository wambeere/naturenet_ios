//
//  Observation.swift
//  NatureNet
//
//  Created by James B on 6/29/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import Foundation

class ObservationForLater : NSObject, NSCoding {
    
    var projectKey : String
    var observationDescription : String
    var imageData = NSData()
    var imageURL : String
    var observerID : String
    var timestamp = ""
    var longitude : Double
    var latitude : Double
    
    //should be replaced with more secure storage (ie keychain)
    var email : String
    var password : String
    
    var imageUploaded : Bool
    
    init (projectKey:String, observationDescription:String, imageData:NSData, imageURL:String, observerID:String, timestamp:String, longitude:Double, latitude:Double, email:String, password:String, imageUploaded:Bool)
    {
        self.projectKey = projectKey
        self.observationDescription = observationDescription
        self.imageData = imageData
        self.imageURL = imageURL
        self.observerID = observerID
        self.timestamp = timestamp
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
        self.timestamp = decoder.decodeObjectForKey("timestamp") as! String
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
        coder.encodeObject(self.timestamp, forKey: "timestamp")
        coder.encodeObject(self.longitude, forKey: "longitude")
        coder.encodeObject(self.latitude, forKey: "latitude")
        coder.encodeObject(self.email, forKey: "email")
        coder.encodeObject(self.password, forKey: "password")
        coder.encodeObject(self.imageUploaded, forKey: "imageUploaded")
        
    }
}