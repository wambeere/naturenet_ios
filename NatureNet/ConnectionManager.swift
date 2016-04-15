//
//  ConnectionManager.swift
//  NatureNet
//
//  Created by Abhinay Balusu on 4/7/16.
//  Copyright © 2016 NatureNet. All rights reserved.
//

import Foundation
import Firebase

let OBSERVATIONS_URL = "https://naturenet-testing.firebaseio.com/observations.json?orderBy=%22$key%22&limitToFirst=10"
let USERS_URL = "https://naturenet-testing.firebaseio.com/users/"
let FIREBASE_URL = "https://naturenet-testing.firebaseio.com/"
let POST_OBSERVATION_URL = "https://naturenet-testing.firebaseio.com/observations/"

//let OBSERVATIONS_URL = "https://naturenet-staging.firebaseio.com/observations.json?orderBy=%22$key%22&limitToFirst=10"
//let USERS_URL = "https://naturenet-staging.firebaseio.com/users/"
//let FIREBASE_URL = "https://naturenet-staging.firebaseio.com/"

class ConnectionManager{
    
    static let sharedManager = ConnectionManager()
    
}
