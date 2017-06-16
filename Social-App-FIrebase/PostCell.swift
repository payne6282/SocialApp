//
//  PostCell.swift
//  Social-App-FIrebase
//
//  Created by newmac on 6/7/17.
//  Copyright © 2017 Sachin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var placeHolderImg: UIImageView!
    @IBOutlet weak var DescLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesCountLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
