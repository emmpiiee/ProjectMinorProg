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
    
    var filenames: Array<String>? = []
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        
        var folderId : Array<Files.SearchMatch>
        var accountId = String()
        
        let accesToken = "9jdMHYq2mWAAAAAAAAAAImt9zBjH-LVWlaMy0U8tk8RDSCLk5kdxTDpRXZzKUb9a"
        let uid = "PackTag"
        let packTagClient = DropboxClient.init(accessToken: DropboxAccessToken(accessToken: accesToken, uid: uid))
        
        if (eventId.text! == ""){
            TodoManager.sharedInstance.path = ""
        }
        else {
            TodoManager.sharedInstance.path = "/\(eventId.text!)"
        }
        
        packTagClient.users.getCurrentAccount().response { response, error in
            print("*** Get current account pagtag ***")
            if let account = response {
                print("Hello \(account.name.givenName)!")
                
            } else {
                print(error!)
            }
        }
        // List folder
            packTagClient.files.listFolder(path: "/\(TodoManager.sharedInstance.path)").response { response, error in
                print("*** List folder packtag ***")
                print("-----------------------------------\(response?.cursor)")
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
            }
        }
//                    packTagClient.files.search(path: "", query: "Event1").response { response, error in
//                        if let result = response {
//                            folderId = result.matches
//                        }
//                        else {
//                            print(error!)
//                        }
//        }
        
        let memberSelector = Sharing.MemberSelector.Email("emmaimmink@hotmail.com")
        let addMember = Sharing.AddMember(member: memberSelector)
        var arrayAddMember = Array<Sharing.AddMember>()
        arrayAddMember.append(addMember)

//        packTagClient.sharing.addFolderMember(sharedFolderId: folderId, members: arrayAddMember)
//        

        
        
        
        
//        if (Dropbox.authorizedClient == nil) {
//            Dropbox.authorizeFromController(self)
//        } else {
//            print("User is already authorized!")
//            print(Dropbox.authorizedClient!)
//        }
//        
//        let client = Dropbox.authorizedClient
//        let memberSelector = Sharing.MemberSelector.Email("packtagapp@gmail.com")
//        let addMember = Sharing.AddMember(member: memberSelector)
//        var arrayAddMember = Array<Sharing.AddMember>()
//        arrayAddMember.append(addMember)
//        
//        client!.sharing.addFolderMember(sharedFolderId: folderId, members: arrayAddMember)
//        
//        TodoManager.sharedInstance.userName = nameUser.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//    
//    
//    
//    @IBOutlet weak var nameUser: UITextField!
//    @IBOutlet weak var eventId: UITextField!
//    var filenames: Array<String>? = []
//    
//    @IBAction func linkButtonPressed(sender: AnyObject) {
//        var folderId = String()
//        var accountId = String()
//        
//        let accesToken = "9jdMHYq2mWAAAAAAAAAAImt9zBjH-LVWlaMy0U8tk8RDSCLk5kdxTDpRXZzKUb9a"
//        let uid = "PackTag"
//        var packTagClient = DropboxClient.init(accessToken: DropboxAccessToken(accessToken: accesToken, uid: uid))
//        
//                    packTagClient.files.getMetadata(path: "/Event1").response { response, error in
//                        if let result = response {
//                            let folderId = result.parentSharedFolderId
//                            print("this is folder id \(folderId)")
//                        }
//                        else {
//                            print(error!)
//                        }
//        }
//        
//        if (Dropbox.authorizedClient == nil) {
//            Dropbox.authorizeFromController(self)
//        } else {
//            print("User is already authorized!")
//            print(Dropbox.authorizedClient!)
//        }
//        
//        if let client = Dropbox.authorizedClient {
//            client.users.getCurrentAccount().response { response, error in
//                            print("*** Get current account ***")
//                            if let account = response {
//                                print("Hello \(account.name.givenName)!")
//                                accountId = account.accountId
//                            } else {
//                                print(error!)
//                            }
//                        }
//        }
//        let memberSelector = Sharing.MemberSelector.DropboxId(accountId)
//        let addMember = Sharing.AddMember(member: memberSelector)
//        
//        var arrayAddMember = Array<Sharing.AddMember>()
//        arrayAddMember.append(addMember)
//        print("hier wordt arrayaddmember geprint \(arrayAddMember)")
//        
//        packTagClient.sharing.addFolderMember(sharedFolderId: folderId, members: arrayAddMember)
//        
//        
////        if (Dropbox.authorizedClient == nil) {
////            Dropbox.authorizeFromController(self)
////            let client = Dropbox.authorizedClient
////            client?.files.getMetadata(path: "").response { response, error in
////                if let result = response {
////                    let folderId = result.parentSharedFolderId
////                }
////                else {
////                    print(error!)
////                }
////            client!.users.getCurrentAccount().response { response, error in
////                print("*** Get current account ***")
////                if let account = response {
////                    print("Hello \(account.name.givenName)!")
////                    accountId = account.accountId
////                } else {
////                    print(error!)
////                }
////            }
////                
////                let memberSelector = Sharing.MemberSelector.DropboxId(accountId)
////                let addMember = Sharing.AddMember(member: memberSelector)
////                print("\(addMember)")
////                
////                var arrayAddMember = Array<Sharing.AddMember>()
////                arrayAddMember.append(addMember)
////                print("\(arrayAddMember)")
////                
//////                var member = Array<Sharing.AddMember>()
//////                member.append(Sharing.MemberSelector.DropboxId(accountId))
//////                client?.sharing.addFolderMember(sharedFolderId: folderId, members:  client?.get .Sharing.AddFolderMemberArg)
////            } } else {
////            
////            let client = Dropbox.authorizedClient
////            clienttest.files.listFolder(path: "").response { response, error in
////                print("*** List folder test ***")
////                print("-----------------------------------\(response?.cursor)")
////                if let result = response {
////                    print("Folder contents:")
////                    for entry in result.entries {
////                        
////                        print(entry.name)
////                        self.filenames?.append(entry.name)
////                        print("dit is de array filenames \(self.filenames)")
////                        // download a file
////                        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
////                            let fileManager = NSFileManager.defaultManager()
////                            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
////                            // generate a unique name for this file in case we've seen it before
////                            let UUID = NSUUID().UUIDString
////                            let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
////                            return directoryURL.URLByAppendingPathComponent(pathComponent)
////                        }}}}
////        }
//        
//        if (Dropbox.authorizedClient == nil) {
//            Dropbox.authorizeFromController(self)
//        } else {
//            print("User is already authorized!")
//            print(Dropbox.authorizedClient!)
//        }
//        TodoManager.sharedInstance.userName = nameUser.text!
////        
////        let memberSelector = Sharing.MemberSelector.DropboxId(accountId)
////        let addMember = Sharing.AddMember(member: memberSelector)
////        
////        var arrayAddMember = Array<Sharing.AddMember>()
////                    arrayAddMember.append(addMember)
////
////        
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}