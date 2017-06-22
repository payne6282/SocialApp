//
//  PostCell.swift
//  Social-App-FIrebase
//
//  Created by newmac on 6/7/17.
//  Copyright © 2017 Sachin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Firebase

class PostCell: UITableViewCell {
    
    var post: Posts!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var placeHolderImg: UIImageView!
    @IBOutlet weak var DescLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesCountLbl: UILabel!
    
    
    
    func configureCell(post: Posts, image: UIImage? = nil) {
        self.post = post
        self.DescLbl.text = post.postCaption
        self.likesCountLbl.text = "\(post.postLikes)"
        if image != nil {
            print("Sac: Image is not nil")
            self.placeHolderImg.image = image
        } else {
            print("Sac: Reaching inside storage ref")
            let storageRef = FIRStorage.storage().reference(forURL: post.postImageUrl)
            storageRef.data(withMaxSize: 2 * 1024 * 1024, completion:  { (data, error) in
                if error != nil {
                    print("Sac: Some error in image")
                } else {
                    print("Sac: Image downloaded")
                    if let image = UIImage(data: data!) {
                        self.placeHolderImg.image = image
                        FeedVC.imageCache.setObject(image, forKey: post.postImageUrl as NSString)
                    }
                    
                }
                
            })
        }
    }
    
    //Code for getting images from url using Alamofire
    /*let downloadUrl = post.postImageUrl
     Alamofire.request(downloadUrl).responseImage { response in
     if let image = response.result.value {
     self.placeHolderImg.image = image*/
    
}
