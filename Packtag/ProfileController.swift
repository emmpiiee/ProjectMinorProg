//
//  ProfileController.swift
//  Packtag
//
//  Created by Emma Immink on 07-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ProfileController: UIViewController {
    // Create outlets and variables.
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var editProfile: UIButton!
    @IBAction func editProfile(sender: AnyObject){
        print("users want to edit profile")
    }
    var profileUsername = Profile.currentUser?.username
    var userProfile: Profile?
    var usersId = String()
    var filenames = Array<String>()
    var fileImage = UIImage?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show edit if current user same as profileUser.
        if (TodoManager.sharedInstance.userId == TodoManager.sharedInstance.profileViewId || TodoManager.sharedInstance.profileViewId == ""){
            print("hallo")
        }
            // Don't show edit if current user and profile user are different.
        else {
            editProfile.hidden = true
        }
        // If no profileViewId then current user is profileViewID.
        if (TodoManager.sharedInstance.profileViewId == "") {
            TodoManager.sharedInstance.profileViewId = TodoManager.sharedInstance.userId
        }
        profilePic.image = fileImage
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // If view appears, reload profile.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileController.reloadProfile), name: "reloadProfile", object: nil)
        if (TodoManager.sharedInstance.lastShowedProfileId == TodoManager.sharedInstance.profileViewId) {
            return
        }
        else {
            var filenames: Array<String>? = []
            if let client = Dropbox.authorizedClient {
                // List folder
                client.files.listFolder(path: "\(TodoManager.sharedInstance.path)").response { response, error in
                    if let result = response {
                        for entry in result.entries {
                            let subString = self.getStringsBeforeCharacter(entry.name, character: "`")
                            if(subString.count == 2) {
                                filenames?.append(entry.name)
                                // download a file
                                let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                                    let fileManager = NSFileManager.defaultManager()
                                    let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                                    // generate a unique name for this file in case we've seen it before
                                    let UUID = NSUUID().UUIDString
                                    let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                                    return directoryURL.URLByAppendingPathComponent(pathComponent)
                                }
                                // Download files from filenames.
                                client.files.download(path: "\(TodoManager.sharedInstance.path)/\(entry.name)", destination: destination).response { response, error in
                                    if let (metadata, url) = response {
                                        if (subString[0] == TodoManager.sharedInstance.profileViewId){
                                            let data = NSData(contentsOfURL: url)
                                            let picture = UIImage (data: data!)
                                            self.fileImage = picture!
                                            self.profilePic.image = self.fileImage
                                            TodoManager.sharedInstance.profileViewId = ""
                                        }
                                    } else {
                                        print(error!)
                                    }
                                }
                            }
                        }
                    }
                    TodoManager.sharedInstance.arrayProfilePhotoNames = filenames!
                }
            }
        }
    }
    
    // Function to get array of strings before certain character.
    func getStringsBeforeCharacter (string: String, character: String) -> Array<String> {
        let subStringBefore = (string.componentsSeparatedByString(character))
        return subStringBefore
    }
    
    // function to reload profile.
    func reloadProfile (){
        viewDidLoad()
        viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}