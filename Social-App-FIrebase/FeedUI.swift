//
//  FeedUI.swift
//  Social-App-FIrebase
//
//  Created by newmac on 6/1/17.
//  Copyright © 2017 Sachin. All rights reserved.
//

import Foundation

class FeedUI {
    
    private var _emailId: String!
    
    var emailId: String {
        if _emailId == nil {
            return ""
        }
        return _emailId
    }
    
    init(email: String) {
        self._emailId = email
    }
    
}
