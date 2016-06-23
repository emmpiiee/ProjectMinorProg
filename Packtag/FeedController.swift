//
//  FeedController.swift
//  Packtag
//
//  Created by Emma Immink on 07-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import SwiftyDropbox

class FeedController: UITableViewController {
    
    // Set outlet for button to change Event.
    @IBOutlet weak var changeEvent: UIBarButtonItem!
    // Make variables.
    var checker = true
    var cursor1 = String()
    var filenames: Array<String>? = []
    var fileImages: Array<UIImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make pull refresh
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // If view will appear reload data and pull refresh.
        tableView.reloadData()
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Get current user.
        if let client = Dropbox.authorizedClient {
            client.users.getCurrentAccount().response { response, error in
                if let account = response {
                    // Set user id to current user Id
                    TodoManager.sharedInstance.userId = account.accountId
                    // Capitalize names and set userName to current user name.
                    let name = String(account.name.givenName.characters.prefix(1)).uppercaseString + String(account.name.givenName.characters.dropFirst())
                    let surname = String(account.name.surname.characters.prefix(1)).uppercaseString + String(account.name.surname.characters.dropFirst())
                    TodoManager.sharedInstance.userName = "\(name) \(surname)"
                } else {
                    print(error!)
                }
            }
            // List folder
            // Execute 1 time
            if checker {
                checker = false
                updateList(client, path: TodoManager.sharedInstance.path)
            }
            else if (cursor1 == ""){
                updateList(client, path: TodoManager.sharedInstance.path)
            }
            else {
                updateList(client, cursor: self.cursor1)
            }
        } else {
            print("error")
        }
    }
    
    // Function get list to get list for the first time
    func updateList (client: DropboxClient, path: String) {
        client.files.listFolder(path: "\(TodoManager.sharedInstance.path)").response { response, error in
            if let result = response {
                // Get all folder names and store in filenames.
                for entry in result.entries {
                    print(entry.name)
                    self.filenames?.append(entry.name)
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
                            let subString = self.getStringsBeforeCharacter(metadata.name, character: "`")
                            if (subString.count == 6){
                                print(subString.count)
                                let data = NSData(contentsOfURL: url)
                                let picture = UIImage (data: data!)
                                self.fileImages?.append(picture!)
                                // Get creator and caption and make new post.
                                let creator = subString[0]
                                let caption = subString[1]
                                let id = subString[2]
                                let newPost = Post.init(creator: "\(creator)", image: picture!, caption: "\(caption)", id: "\(id)")
                                Post.feed!.append(newPost)
                            }
                        } else {
                            print(error!)
                        }
                        self.reloadTable()
                    }
                    // Set cursor to cursor1.
                    self.cursor1 = result.cursor
                }
            } else {
                print(error!)
            }
        }
    }
    
    // Function updatelist to get the updates of the current list.
    func updateList (client: DropboxClient, cursor: String) {
        client.files.listFolderContinue(cursor: cursor).response { response, error in
            if let result = response {
                for entry in result.entries {
                    // Get all folder names and store in filenames.
                    self.filenames?.append(entry.name)
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
                            let subString = self.getStringsBeforeCharacter(metadata.name, character: "`")
                            if (subString.count == 6) {
                                let data = NSData(contentsOfURL: url)
                                let picture = UIImage (data: data!)
                                self.fileImages?.append(picture!)
                                // Get creator and caption and make new post.
                                let creator = subString[0]
                                let caption = subString[1]
                                let id = subString[2]
                                let newPost = Post.init(creator: "\(creator)", image: picture!, caption: "\(caption)", id: "\(id)")
                                Post.feed!.append(newPost)
                            }
                        } else {
                            print(error!)
                        }
                    }
                    // Set cursor to cursor1
                    self.cursor1 = result.cursor
                }
            } else {
                print(error!)
            }
        }
    }
    
    // Return to view before tapBar.
    @IBAction func changeEventClicked(sender: AnyObject) {
        Post.feed?.removeAll()
        _ = self.presentingViewController as? UITabBarController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // every section needs only 1 row for only 1 post
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // every post needs to be in a different section so return number of posts
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let feed = Post.feed{
            return feed.count
        }
        else {
            return 0
        }
    }
    
    // relaod table
    func reloadTable (){
        return
    }

    // make sure latest post is first
    func postIndex(cellIndex : Int) -> Int {
        return tableView.numberOfSections - cellIndex - 1
    }
    
    // func to get array of strings before certain character
    func getStringsBeforeCharacter (string: String, character: String) -> Array<String> {
        let subStringBefore = (string.componentsSeparatedByString(character))
        return subStringBefore
    }
    
    // sets header in feeds
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewCell {
        let post = Post.feed![postIndex(section)]
        let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeaderCell") as? PostHeaderCell
        if (post.creator == Profile.currentUser?.username) {
            headerCell!.profilePicture.image = Profile.currentUser?.picture
        }
        else{
            // don't have permission someone else's photo
            // set to creators image
        }
        headerCell?.usernameButton.setTitle(post.creator, forState: .Normal)
        headerCell?.userId.text = post.id
        headerCell?.userId.hidden = true
        return headerCell!
    }
    
    // set posts in table view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = Post.feed![postIndex(indexPath.section)]
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        cell.captionLabel.text = post.caption
        cell.imgView.image = post.image
        TodoManager.sharedInstance.arrayProfileId.append(post.id!)
        return cell
    }
    
    // sets height for header for username and profile picture
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    // sets height for each row inside tableview (every post has a row)
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = Post.feed![postIndex(indexPath.section)]
        if let img = post.image {
            let aspectRatio = img.size.height / img.size.height
            return tableView.frame.size.width * aspectRatio + 80
        }
        return 208
    }
    
    // Get indexpath of tableview
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = self.tableView.indexPathForSelectedRow
        indexPath?.row
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        
        // Unwrap that optional
        if let label = cell?.textLabel?.text {
            print("Tapped \(label)")
        }
    }
    
    // Refresh table view
    func refresh(sender:AnyObject) {
        viewWillAppear(true)
    }
    
    
    @IBAction func showUsersProfile(sender: UIButton){
        let mainSB = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let profileVC = mainSB.instantiateViewControllerWithIdentifier("Profile") as! ProfileController
        profileVC.profileUsername = sender.currentTitle
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        navigationController?.pushViewController(profileVC, animated: true)
    }
}