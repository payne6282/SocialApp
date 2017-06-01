//
//  feedVC.swift
//  Social-App-FIrebase
//
//  Created by newmac on 6/1/17.
//  Copyright © 2017 Sachin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {
    
    var email: String!

    @IBOutlet weak var helloLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let email = email {
        helloLabel.text = "Hello " + email
        } else {
            helloLabel.text = "Hello User"
        }

        // Do any additional setup after loading the view.
    }
    
    
  //  func updateUserName() {
  //      print("Sac: Comes to trying update label")
  //      helloLabel.text = socialAppVC.emailField
   // }

    @IBAction func signOutBtn(_ sender: AnyObject) {
        print("Sac: Came to feedVC")
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        do {
            
            try FIRAuth.auth()?.signOut()
 
        } catch let error as NSError {
            
            print("Sac: Error signing out of firebase with error - \(error)")
            
        }
            
            print("Sac: Signing out with no errors")
        
        performSegue(withIdentifier: "signInVC", sender: self)
    }


}
