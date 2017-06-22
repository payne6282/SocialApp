//
//  Dataservice.swift
//  Social-App-FIrebase
//
//  Created by newmac on 6/15/17.
//  Copyright © 2017 Sachin. All rights reserved.
//

import Foundation
import Firebase

class Dataservice {
    
    static let db = Dataservice()
   
    //DB variables
    private let _BASE_DBURL = BASE_URL
    private let _BASE_USER = BASE_URL.child("users")
    private let _BASE_POSTS = BASE_URL.child("Posts")
    
    //Storage variables
    private let _BASE_STORAGE = STORAGE_URL.child("postpics")
    
    var BASE_DBURL: FIRDatabaseReference {
        return _BASE_DBURL
    }
    
    var BASE_USER: FIRDatabaseReference {
        return _BASE_USER
    }
    
    var BASE_POSTS: FIRDatabaseReference {
        return _BASE_POSTS
    }
    
    var BASE_STORAGE: FIRStorageReference {
        return _BASE_STORAGE
    }
    
    func createfireBaseUser (uid: String, userData: Dictionary<String, String>) {
        BASE_USER.child(uid).updateChildValues(userData)
        
    }
    
}
