//
//  Feed.swift
//  Social-App-FIrebase
//
//  Created by newmac on 6/16/17.
//  Copyright © 2017 Sachin. All rights reserved.
//

import Foundation
import Firebase

class Posts {
    
    private var _postKey: String!
    private var _postCaption: String!
    private var _postImageUrl: String!
    private var _postLikes: Int!
    
    var postKey: String {
        return _postKey
    }
    
    var postCaption: String {
        return _postCaption
    }
    
    var postImageUrl: String {
        return _postImageUrl
    }
    
    var postLikes: Int {
        return _postLikes
    }
    
    init(postCaption: String, postImageUrl: String, postLikes: Int) {
        self._postCaption = postCaption
        self._postImageUrl = postImageUrl
        self._postLikes = postLikes
    }
    
    init(key: String, dict: Dictionary<String, AnyObject>) {
        self._postKey = key
        
        if let caption = dict["caption"] as? String {
            self._postCaption = caption
            print("Sac: Caption? \(self._postCaption)")
        }
        
        if let likes = dict["likes"] as? Int {
            self._postLikes = likes
        }
        
        if let imageUrl = dict["picurl"] as? String {
            self._postImageUrl = imageUrl
        }
        
        
    }
    
}
