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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var email: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    var posts = [Posts]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.setEmail()
        
        Dataservice.db.BASE_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("sac: \(snap)")
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Posts(key: key, dict: value)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postDisplay = posts[indexPath.row]
        print("sac: \(postDisplay.postCaption)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell {
                    cell.configureCell(post: postDisplay)
                    return cell
                }
                else {
                    return PostCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func setEmail() {
        
        if let email = email {
            helloLabel.text = "Hello " + email
        } else {
            helloLabel.text = "Hello User"
        }
    }
    
    
}
