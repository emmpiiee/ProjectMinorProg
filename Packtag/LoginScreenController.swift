//
//  LoginScreen.swift
//  Packtag
//
//  Created by Emma Immink on 13-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import SwiftyDropbox

class LoginScreenController: UIViewController {
    
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var eventId: UITextField!
    @IBOutlet weak var createId: UITextField!
    @IBOutlet weak var eventNotExisting: UILabel!
    @IBOutlet weak var eventExisting: UILabel!
    @IBOutlet weak var changeAccount: UIButton!
    @IBOutlet weak var eventMade: UILabel!
    @IBOutlet weak var makeNewEvent: UIButton!
    
    var filenames: Array<String>? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        eventNotExisting.hidden = true
        eventExisting.hidden = true
        eventMade.hidden = true
        if let client = Dropbox.authorizedClient{
            client.users.getCurrentAccount().response { response, error in
                if let account = response {
                    print("\(account.name)")
                    self.changeAccount.titleLabel?.text = "Not \(account.name.givenName)?"
                }
            }
        }
        else{
            changeAccount.titleLabel?.text = "Log in"
        }
    }
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        
        //        var folderId = Files.SearchMatch.self
        var accountId = String()
        //        var folderIdString = String?()
        
        let accesToken = "9jdMHYq2mWAAAAAAAAAAImt9zBjH-LVWlaMy0U8tk8RDSCLk5kdxTDpRXZzKUb9a"
        let uid = "PackTag"
        let packTagClient = DropboxClient.init(accessToken: DropboxAccessToken(accessToken: accesToken, uid: uid))
        
        if (eventId.text! == ""){
            TodoManager.sharedInstance.path = ""
        }
        else {
            TodoManager.sharedInstance.path = "/\(eventId.text!)"
        }
        
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
            print(Dropbox.authorizedClient!)
        }

        // List folder
        packTagClient.files.listFolder(path: "").response { response, error in
            print("*** List folder packtag ***")
            if let result = response {
                print("Folder contents:")
                for entry in result.entries {
                    print(entry.name)
                    self.filenames?.append(entry.name)
                    print("dit is de array filenames \(self.filenames)")
                    // download a file
                    let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                        let fileManager = NSFileManager.defaultManager()
                        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                        // generate a unique name for this file in case we've seen it before
                        let UUID = NSUUID().UUIDString
                        let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                        return directoryURL.URLByAppendingPathComponent(pathComponent)
                    }
                }
                let exists = self.filenames?.contains(self.eventId.text!)
                if exists! {
                    print("wordt dit uitgevoerd")
                    packTagClient.files.search(path: "", query: "\(self.eventId.text!)").response { response, error in
                        if let result = response {
                            let folderIdString = result.matches[0].description
                            print("folder id string\(folderIdString)")
                            
                            let subString = folderIdString.componentsSeparatedByString("shared_folder_id")
                            print(subString)
                            let folderId = subString[1].componentsSeparatedByString("=")
                            print("folderId is nu \(folderId)")
                            let folderId1 = folderId[1].componentsSeparatedByString(";")
                            print("folderid1 \(folderId1[0])einde")
                            let folderId2 = folderId1[0]
                            print("folderId2 = ....\(folderId2)....")
                            let folderId3 = folderId2.substringFromIndex(folderId2.startIndex.successor())
                            print("folderId3 = ....\(folderId3)....")
                            
                            let memberSelector = Sharing.MemberSelector.Email("emmaimmink@hotmail.com")
                            print("member selector\(memberSelector)")
                            let addMember = Sharing.AddMember(member: memberSelector)
                            var arrayAddMember = Array<Sharing.AddMember>()
                            arrayAddMember.append(addMember)
                            
                            packTagClient.sharing.addFolderMember(sharedFolderId: folderId3, members: arrayAddMember, quiet: true, customMessage: "Hallo, dit is een automatisch gegenereerd bericht.").response { response, error in
                                if let errorcode = error {
                                    print("errorcode is \(errorcode)")
                                }
                            }
                            if let client = Dropbox.authorizedClient{
                                client.sharing.mountFolder(sharedFolderId: folderId3)
                            }
                            
                        }
                    }
                    
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let resultViewController = storyboard.instantiateViewControllerWithIdentifier("ChooseEvent")
                    self.presentViewController(resultViewController, animated: true, completion: nil)
                    
//                    let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FeedController") as! FeedController
//                    self.navigationController!.pushViewController(secondViewController, animated: true)
                }
                else {
                    self.eventNotExisting.hidden = false
                    self.delay(3){
                        self.eventNotExisting.hidden = true
                    }
                    
                }
            }
        }
    }

    func delay(delay: Double, closure: ()->()){
        dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }

    @IBAction func makeNewEvent(sender: AnyObject) {
        filenames?.removeAll()
        let accesToken = "9jdMHYq2mWAAAAAAAAAAImt9zBjH-LVWlaMy0U8tk8RDSCLk5kdxTDpRXZzKUb9a"
        let uid = "PackTag"
        let packTagClient = DropboxClient.init(accessToken: DropboxAccessToken(accessToken: accesToken, uid: uid))
        packTagClient.files.listFolder(path: "").response { response, error in
            print("*** List folder packtag ***")
            if let result = response {
                print("Folder contents:")
                for entry in result.entries {
                    print(entry.name)
                    self.filenames?.append(entry.name)
                    print("dit is de array filenames \(self.filenames)")
                    // download a file
                    let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                        let fileManager = NSFileManager.defaultManager()
                        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                        // generate a unique name for this file in case we've seen it before
                        let UUID = NSUUID().UUIDString
                        let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                        return directoryURL.URLByAppendingPathComponent(pathComponent)
                    }
                }
        let exists = self.filenames?.contains(self.createId.text!)
        print("this is filenames \(self.filenames!)")
        print(exists!)
        if exists! {
            print("this already exists")
            self.eventExisting.hidden = false
            self.delay(3){
                self.eventExisting.hidden = true
            }
        }
        else{
                self.eventMade.hidden = false
                self.makeNewEvent.hidden = true
            self.delay(6){
                self.eventMade.hidden = true
                self.makeNewEvent.hidden = false
            }
                packTagClient.files.createFolder(path: "/\(self.createId.text!)")
                packTagClient.sharing.shareFolder(path: "/\(self.createId.text!)")
                }
            }
        }
    }
    
    @IBAction func tap (sender: UITapGestureRecognizer!){
        eventId.resignFirstResponder()
        createId.resignFirstResponder()
    }
    
    @IBAction func changeUserClicked(sender: AnyObject) {
        Dropbox.unlinkClient()
        Dropbox.authorizeFromController(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
