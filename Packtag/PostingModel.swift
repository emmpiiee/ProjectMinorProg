//
//  PostingModel.swift
//  Packtag
//
//  Created by Emma Immink on 07-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import Foundation

// Create class Post to store variables for feeds
class Post{
    let creator:String
    let timestamp:NSDate
    let image:UIImage?
    let caption:String?
    let id: String?
    static var feed:Array<Post>?
    
    // initialize Post class
    init(creator:String, image:UIImage?, caption:String?, id:String?){
        self.creator = creator
        self.image = image
        self.caption = caption
        self.id = id
        timestamp = NSDate()
    }
}

// create class PostCell to change view of postcell
class PostCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}

class PostHeaderCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var userId: UILabel!
    @IBAction func showUsersProfile(sender: UIButton){
        print("user id\(userId.text)")
        print("user name \(usernameButton.currentTitle)")
        TodoManager.sharedInstance.profileViewId = userId.text!
    }
}