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
    @IBOutlet weak var editProfile: UIButton!
    @IBAction func editProfile(sender: AnyObject){
        print("users want to edit profile")
    }
    var profileUsername = Profile.currentUser?.username
    var userProfile: Profile?
    var usersId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (TodoManager.sharedInstance.userId == TodoManager.sharedInstance.profileViewId){
            editProfile.hidden = true
        }
        else {
            
        }
        if let currentUser = Profile.currentUser {
            self.postsLabel.text = "\(currentUser.posts.count)"
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