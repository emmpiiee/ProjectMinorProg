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
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
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
        if (TodoManager.sharedInstance.userId == TodoManager.sharedInstance.profileViewId){
            print("dit is de gelijk aan: user id \(TodoManager.sharedInstance.userId) en profileviewid \(TodoManager.sharedInstance.profileViewId)")
        }
        else {
            editProfile.hidden = true
            print("dit is ongelijk aan aan: user id \(TodoManager.sharedInstance.userId) en profileviewid \(TodoManager.sharedInstance.profileViewId)")
        }
        profilePic.image = fileImage
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (TodoManager.sharedInstance.lastShowedProfileId == TodoManager.sharedInstance.profileViewId) {
            return
        }
        else {
        var filenames: Array<String>? = []
        if let client = Dropbox.authorizedClient {
            // List folder
            client.files.listFolder(path: "\(TodoManager.sharedInstance.path)").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    for entry in result.entries {
//                        let subString = self.getStringsBeforeCharacter(entry.name, character: "`")
//                        if(subString.count == 4) {
                        filenames?.append(entry.name)
                        print("dit is de array filenames \(filenames)")
                        // download a file
                        
                        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                            let fileManager = NSFileManager.defaultManager()
                                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                                // generate a unique name for this file in case we've seen it before
                                let UUID = NSUUID().UUIDString
                                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                                return directoryURL.URLByAppendingPathComponent(pathComponent)
                            }
                            client.files.download(path: "\(TodoManager.sharedInstance.path)/\(entry.name)", destination: destination).response { response, error in
                                if let (metadata, url) = response {
                                    print("*** Download file ***")
                                    let subString = self.getStringsBeforeCharacter(metadata.name, character: "`")
                                    if (subString.count == 4){
                                        print("het is 4 \(subString.count)")
                                        if (subString[1] == TodoManager.sharedInstance.profileViewId){
                                        let data = NSData(contentsOfURL: url)
                                        let picture = UIImage (data: data!)
                                        print("Downloaded file name: \(metadata.name)")
                                        print("Downloaded file url: \(url)")
                                        self.fileImage = picture!
                                        self.profilePic.image = self.fileImage
                                        }
                                    }
                                } else {
                                    print(error!)
                                }
                            }
//                        }
                    }
                }
            }
        }
        }
    }
    
    // func to get array of strings before certain character
    func getStringsBeforeCharacter (string: String, character: String) -> Array<String> {
        let subStringBefore = (string.componentsSeparatedByString(character))
        return subStringBefore
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}