//
//  ViewController.swift
//  Social-App-FIrebase
//
//  Created by newmac on 5/18/17.
//  Copyright © 2017 Sachin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SocialAppVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func FBButtonClicked(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Sac: unable to authenticate with facebook \(error)")
                
            } else if result?.isCancelled == true {
                print("Sac: The user cancelled the authetication")
            } else {
                print("Sac: Succesfully authenticated FB")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseLogin(credential)
                
            }
        }
    }
    
    func fireBaseLogin(_ credentials: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            
            if error != nil {
                print("Sac: Unable to authenticate on Firebase side")
                
            } else {
                
                print("Sac: Succesfully autheticated with firebase")
            }
        })
    }
}

