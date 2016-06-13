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
    
    // reload data if home is clicked
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedController.reloadTable), name: "reloadTable", object: nil)
        
        var filenames: Array<String>?
        var fileImages: Array<UIImage>?
        if let client = Dropbox.authorizedClient {
        print(client)
            
        client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
        }
        // List folder
        client.files.listFolder(path: "").response { response, error in
            print("*** List folder ***")
            if let result = response {
                print("Folder contents:")
                for entry in result.entries {
                    print(entry.name)
                    filenames?.append(entry.name)
                    }
            } else {
                print(error!)
                }
        }
        // download a file
        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            // generate a unique name for this file in case we've seen it before
            let UUID = NSUUID().UUIDString
            let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
            return directoryURL.URLByAppendingPathComponent(pathComponent)
        }
        client.files.download(path: "/2015-07-14 13.16.30 kopie.jpg", destination: destination).response { response, error in
            if let (metadata, url) = response {
                print("*** Download file ***")
                let data = NSData(contentsOfURL: url)
                let picture = UIImage (data: data!)
                print("Downloaded file name: \(metadata.name)")
                print("Downloaded file url: \(url)")
                fileImages?.append(picture!)
                let newPost = Post.init(creator: "joe", image: picture!, caption: "test")
                Post.feed!.append(newPost)
            } else {
                print(error!)
            }
        }
        
        } else {
            print("error")
            }
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
        print("reloads table")
        tableView.reloadData()
    }
    
    // make sure latest post is first
    func postIndex(cellIndex : Int) -> Int {
        return tableView.numberOfSections - cellIndex - 1
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
        
        return headerCell!
    }
    
    // set posts in table view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = Post.feed![postIndex(indexPath.section)]
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        cell.captionLabel.text = post.caption
        cell.imgView.image = post.image
        
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
}