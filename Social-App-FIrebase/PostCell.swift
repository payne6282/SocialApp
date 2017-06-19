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

class PostCell: UITableViewCell {
    
    var post: Posts!

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var placeHolderImg: UIImageView!
    @IBOutlet weak var DescLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesCountLbl: UILabel!

    
    
    func configureCell(post: Posts) {
        self.post = post
        self.DescLbl.text = post.postCaption
        self.likesCountLbl.text = "\(post.postLikes)"
        let downloadUrl = post.postImageUrl
        let urlRequest = URLRequest(url: URL(string: downloadUrl)!)
        let downloader = ImageDownloader()
        Alamofire.request(downloadUrl).responseImage { response in
            if let image = response.result.value {
                self.placeHolderImg.image = image
            }
        }
        
        /*downloader.download(urlRequest) { response in
           
            if let image = response.result.value {
                self.placeHolderImg.image = image
            }
        }*/
        
    }
    
    
    
}
