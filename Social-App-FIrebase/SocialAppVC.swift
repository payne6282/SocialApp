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
import SwiftKeychainWrapper

class SocialAppVC: UIViewController {
    
    @IBOutlet weak var emailFieldTextFld: UITextField!
    @IBOutlet weak var passwdFldTxt: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let keychain = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Sac: Keychain retrieved is \(keychain)")
            EMAIL_PASSED = keychain
            performSegue(withIdentifier: "feedVC", sender: self)
        }
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
                
                if let user = user {
                    print("Sac: This is uid - \(user.uid)")
                    let userData = ["provider": credentials.provider]
                    self.trySaveKeychains(id: user.email!, uid: user.uid, userData: userData)
                    
                }
            }
        })
        
        self.performSegue(withIdentifier: "feedVC", sender: self)
    }
    
    @IBAction func loginBtnPressed(_ sender: AnyObject) {
        
        if let email = emailFieldTextFld.text, let password = passwdFldTxt.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    
                    print("Sac: Authenticate email and password in firebase")
                    
                    if let user = user {
                        print("Sac: This is uid - \(user.email)")
                        let userData = ["provider": user.providerID]
                        self.trySaveKeychains(id: user.email!, uid: user.uid, userData: userData)
                        
                    }
                    
                    self.performSegue(withIdentifier: "feedVC", sender: self)
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error == nil {
                            
                            print("Sac: Able to create a new user")
                            if let user = user {
                                
                                print("Sac: This is uid - \(user.uid)")
                                let userData = ["provider": user.providerID]
                                self.trySaveKeychains(id: user.email!, uid: user.uid, userData: userData)
                                print("Sac: User email- \(user.email) ")
                                
                                
                            }
                            
                        } else {
                            
                            print("Sac: Error creating a new user /(error)")
                        }
                        
                        
                        
                    })
                    
                    self.performSegue(withIdentifier: "feedVC", sender: self)
                }
            })
            
        }
    }
    
    func trySaveKeychains(id: String, uid: String, userData: Dictionary<String, String>) {
        Dataservice.db.createfireBaseUser(uid: uid, userData: userData)
        print("Sac: UID passed in function is - \(id)")
        EMAIL_PASSED = id
        let keyChain = KeychainWrapper.standard.set(id, forKey: "uid")
        print("Sac: Keychain saved \(keyChain)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedVC" {
            if let feedId = segue.destination as? FeedVC {
                print("Sac: Set the email field to segue - \(EMAIL_PASSED)")
                feedId.email = EMAIL_PASSED
                
            }
        }
    }
    

    
    
    
}

