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
    
    var filenames: Array<String>? = []

    
    
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
//        
//        packTagClient.users.getCurrentAccount().response { response, error in
//            print("*** Get current account pagtag ***")
//            if let account = response {
//                print("Hello \(account.name.givenName)!")
//            } else {
//                print(error!)
//            }
//        }
//        // List folder
//        packTagClient.files.listFolder(path: "/\(TodoManager.sharedInstance.path)").response { response, error in
//            print("*** List folder packtag ***")
//            print("-----------------------------------\(response?.cursor)")
//            if let result = response {
//                print("Folder contents:")
//                for entry in result.entries {
//                    print(entry.name)
//                    self.filenames?.append(entry.name)
//                    print("dit is de array filenames \(self.filenames)")
//                    // download a file
//                    let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
//                        let fileManager = NSFileManager.defaultManager()
//                        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
//                        // generate a unique name for this file in case we've seen it before
//                        let UUID = NSUUID().UUIDString
//                        let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
//                        return directoryURL.URLByAppendingPathComponent(pathComponent)
//                    }
//                }
//            }
//        }
        
        packTagClient.files.search(path: "", query: "\(eventId.text!)").response { response, error in
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
                
                
                //                let folderIdString = folderId.metadata
                //                print("folderidstring \(folderIdString)")
                
                
                let memberSelector = Sharing.MemberSelector.Email("emmaimmink@hotmail.com")
                print("member selector\(memberSelector)")
                let addMember = Sharing.AddMember(member: memberSelector)
                var arrayAddMember = Array<Sharing.AddMember>()
                arrayAddMember.append(addMember)
                
                packTagClient.sharing.addFolderMember(sharedFolderId: folderId3, members: arrayAddMember, quiet: true, customMessage: "Hallo, dit is een automatisch gegenereerd bericht.").response { response, error in
                    if let errorcode = error {
                        print("errorcode is \(errorcode)")
                    }
                    if let client = Dropbox.authorizedClient{
                        client.sharing.mountFolder(sharedFolderId: folderId3)
                    }
                }
            }
        }
    }


    @IBAction func makeNewEvent(sender: AnyObject) {
        print("user needs to create a folder")
        let accesToken = "9jdMHYq2mWAAAAAAAAAAImt9zBjH-LVWlaMy0U8tk8RDSCLk5kdxTDpRXZzKUb9a"
        let uid = "PackTag"
        let packTagClient = DropboxClient.init(accessToken: DropboxAccessToken(accessToken: accesToken, uid: uid))
        packTagClient.users.getCurrentAccount().response { response, error in
            print("*** Get current account pagtag ***")
            if let account = response {
                print("Hello \(account.name.givenName)!")
            } else {
                print(error!)
            }
        }
        packTagClient.files.createFolder(path: "/\(createId.text!)")
        packTagClient.sharing.shareFolder(path: "/\(createId.text!)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
