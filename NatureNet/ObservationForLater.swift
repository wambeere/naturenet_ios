//
//  Observation.swift
//  NatureNet
//
//  Created by James B on 6/29/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import Foundation

class ObservationForLater : NSObject, NSCoding {
    var name : String
    var defaultValue : Int
    var thisMonthsEstimate : Int
    var sumOfThisMonthsActuals : Int
    var riskFactor : Float
    var monthlyAverage : Float
    
    var projectKey : String = ""
    var descText :String = ""
    var userID :String = ""
    
    init (name:String, defaultValue:Int, thisMonthsEstimate:Int, sumOfThisMonthsActuals:Int, riskFactor:Float, monthlyAverage:Float) {
        self.name = name
        self.defaultValue = defaultValue
        self.thisMonthsEstimate = thisMonthsEstimate
        self.sumOfThisMonthsActuals = sumOfThisMonthsActuals
        self.riskFactor = riskFactor
        self.monthlyAverage = monthlyAverage
    }
    
    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        //Error here "missing argument for parameter name in call
        self.name = decoder.decodeObjectForKey("name") as! String
        self.defaultValue = decoder.decodeIntegerForKey("defaultValue")
        self.thisMonthsEstimate = decoder.decodeIntegerForKey("thisMonthsEstimate")
        self.sumOfThisMonthsActuals = decoder.decodeIntegerForKey("sumOfThisMonthsActuals")
        self.riskFactor = decoder.decodeFloatForKey("riskFactor")
        self.monthlyAverage = decoder.decodeFloatForKey("monthlyAverage")
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeInt(Int32(self.defaultValue), forKey: "defaultValue")
        coder.encodeInt(Int32(self.thisMonthsEstimate), forKey: "thisMonthsEstimate")
        coder.encodeInt(Int32(self.sumOfThisMonthsActuals), forKey: "sumOfThisMonthsActuals")
        coder.encodeFloat(self.riskFactor, forKey: "riskFactor")
        coder.encodeFloat(self.monthlyAverage, forKey: "monthlyAverage")
        
    }
}