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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var email: String!
    let imagePicker = UIImagePickerController()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    @IBOutlet weak var imageSelect: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var postText: UITextField!
    
    var imageSelected = false
    
    var posts = [Posts]()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
   
    
    @IBAction func makePost(_ sender: AnyObject) {
        guard let post = postText.text, post != ""  else {
            postText.layer.borderColor = UIColor.red.cgColor
            print("Sac: Post should not be empty")
            return
        }
        
        guard let image = imageSelect.image, imageSelected == true else {
            print("Sac: Image should be selected")
            return
        }
        
        //Compress data
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imgUID =  NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            Dataservice.db.BASE_STORAGE.child(imgUID).put(imgData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    print("sac: Some error in uploading images")
                } else {
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    print("Sac: Hopefully images are uploaded")
                    self.postAdded(imageUrl: downloadUrl!)
                    
                }
            }
            
        }
        
        
        
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
            
            if let img = FeedVC.imageCache.object(forKey: postDisplay.postImageUrl as NSString) {
                cell.configureCell(post: postDisplay, image: img)
            } else {
                print("Sac: obviously image did not get passed")
                cell.configureCell(post: postDisplay)
                
            }
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageSelected = true
            imageSelect.image = image
        } else {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageSelected = true
                imageSelect.image = image
            } else {
                print("Sac: Cannot select image")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tappedPic(_ sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func postAdded(imageUrl: String) {
        print("Sac: Reached inside this funcation")
        let postDict: Dictionary<String, AnyObject> = [
        "caption": postText.text! as AnyObject,
         "likes": 0 as AnyObject,
         "picurl": imageUrl as AnyObject]
        
        let firebasePost = Dataservice.db.BASE_POSTS.childByAutoId()
        firebasePost.setValue(postDict)
        
        postText.text = ""
        imageSelected = false
        imageSelect.image = UIImage(named: "Camera Icon")
        
        tableView.reloadData()
        
        
    }
    
    func setEmail() {
        
        if let email = email {
            helloLabel.text = "Hello " + email
        } else {
            helloLabel.text = "Hello User"
        }
    }
    
    
}
