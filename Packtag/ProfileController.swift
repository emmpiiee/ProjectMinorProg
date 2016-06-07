//
//  ProfileController.swift
//  Packtag
//
//  Created by Emma Immink on 07-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel! 
    @IBAction func editProfile(sender: AnyObject){
        print("users want to edit profile")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = Profile.currentUser {
            self.postsLabel.text = "\(currentUser.posts.count)"
            self.followersLabel.text = "\(currentUser.followers.count)"
            self.followingLabel.text = "\(currentUser.following.count)"
            if let profPic = currentUser.picture {
                self.profilePic.image = profPic
            }
        } else {
            print("There is no user logged in")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}