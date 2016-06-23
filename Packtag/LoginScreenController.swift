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
    
    // Creating outlets for labels and buttons.
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var eventId: UITextField!
    @IBOutlet weak var createId: UITextField!
    @IBOutlet weak var eventNotExisting: UILabel!
    @IBOutlet weak var eventExisting: UILabel!
    @IBOutlet weak var changeAccount: UIButton!
    @IBOutlet weak var eventMade: UILabel!
    @IBOutlet weak var makeNewEvent: UIButton!
    @IBOutlet weak var tooLongId: UILabel!
    @IBOutlet weak var noSpacesAllowed: UILabel!
    
    // Create an array for filenames to be stored in.
    var filenames: Array<String>? = []
    
    // Things to do when view did load.
    override func viewDidLoad() {
        super.viewDidLoad()
        labelsToInvisible()
        
        // Put lower label to name of autorizedClient.
        if let client = Dropbox.authorizedClient{
            client.users.getCurrentAccount().response { response, error in
                if let account = response {
                    self.changeAccount.titleLabel?.text = "Not \(account.name.givenName)?"
                }
            }
        }
        else{
            changeAccount.titleLabel?.text = "Log in"
        }
    }
    
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        // Hardcode packTag account.
        let accesToken = "9jdMHYq2mWAAAAAAAAAAImt9zBjH-LVWlaMy0U8tk8RDSCLk5kdxTDpRXZzKUb9a"
        let uid = "PackTag"
        let packTagClient = DropboxClient.init(accessToken: DropboxAccessToken(accessToken: accesToken, uid: uid))
        
        // Make path voor eventId the user choose.
        if (eventId.text! == ""){
            TodoManager.sharedInstance.path = ""
        }
        else {
            TodoManager.sharedInstance.path = "/\(eventId.text!)"
        }
        
        // If no dropbox user is authorized, log in pop-up.
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
            print(Dropbox.authorizedClient!)
        }
        
        // List folder contents.
        packTagClient.files.listFolder(path: "").response { response, error in
            if let result = response {
                for entry in result.entries {
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
                }
                // Check if eventID exists.
                let exists = self.filenames?.contains(self.eventId.text!)
                if exists! {
                    packTagClient.files.search(path: "", query: "\(self.eventId.text!)").response { response, error in
                        if let result = response {
                            // Get correct folderId (dropbox function deprecated).
                            let folderIdString = result.matches[0].description
                            let folderId3 = self.getFolderId(folderIdString)
                            // Get array of members that needs to be added to the folder.
                            let memberSelector = Sharing.MemberSelector.Email("emmaimmink@hotmail.com")
                            print("member selector\(memberSelector)")
                            let addMember = Sharing.AddMember(member: memberSelector)
                            var arrayAddMember = Array<Sharing.AddMember>()
                            arrayAddMember.append(addMember)
                            // Add client to the folder.
                            packTagClient.sharing.addFolderMember(sharedFolderId: folderId3, members: arrayAddMember, quiet: true, customMessage: "Hallo, dit is een automatisch gegenereerd bericht.").response { response, error in
                            }
                            // Make client editor of the file.
                            packTagClient.sharing.updateFolderMember(sharedFolderId: folderId3, member: memberSelector, accessLevel: Sharing.AccessLevel.Editor)
                            // With a 3 seconds delay mount client to the folder.
                            self.delay(3){
                                if let client = Dropbox.authorizedClient{
                                    client.sharing.mountFolder(sharedFolderId: folderId3)
                                }
                            }
                            
                        }
                        
                    }
                    
                    // Go to CheckCorrectEventController
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let resultViewController = storyboard.instantiateViewControllerWithIdentifier("ChooseEvent")
                    self.presentViewController(resultViewController, animated: true, completion: nil)
                }
                    // If eventId not in filenames show label.
                else {
                    self.eventNotExisting.hidden = false
                    self.delay(3){
                        self.eventNotExisting.hidden = true
                    }
                    
                }
            }
        }
    }
    
    // Function that gives a delay before executing code inside.
    func delay(delay: Double, closure: ()->()){
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    // If user want to make a new event.
    @IBAction func makeNewEvent(sender: AnyObject) {
        filenames?.removeAll()
        // HardCode packTagClient.
        let accesToken = "9jdMHYq2mWAAAAAAAAAAImt9zBjH-LVWlaMy0U8tk8RDSCLk5kdxTDpRXZzKUb9a"
        let uid = "PackTag"
        let packTagClient = DropboxClient.init(accessToken: DropboxAccessToken(accessToken: accesToken, uid: uid))
        // List foldernames.
        packTagClient.files.listFolder(path: "").response { response, error in
            if let result = response {
                for entry in result.entries {
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
                }
                // Check if eventId already exists
                let exists = self.filenames?.contains(self.createId.text!)
                if (exists! || self.createId.text! == "" ){
                    // Show label.
                    self.eventExisting.hidden = false
                    self.delay(3){
                        self.eventExisting.hidden = true
                    }
                }
                    // If eventId longer then 30 characters, show label.
                else if (self.createId.text!.characters.count >= 30) {
                    self.tooLongId.hidden = false
                    self.delay(3){
                        self.tooLongId.hidden = true
                    }
                }
                    // if evenId contains spaces show label.
                else if (self.createId.text!.rangeOfString(" ") != nil){
                    self.noSpacesAllowed.hidden = false
                    self.delay(3){
                        self.noSpacesAllowed.hidden = true
                    }
                }
                    // If correct eventId make new folder, show label.
                else{
                    // Show label and hide button for 6 seconds.
                    self.eventMade.hidden = false
                    self.makeNewEvent.hidden = true
                    self.delay(6){
                        self.eventMade.hidden = true
                        self.makeNewEvent.hidden = false
                    }
                    // Make variable so user can't change during folder making.
                    let id = self.createId.text!
                    packTagClient.files.createFolder(path: "/\(id)")
                    packTagClient.sharing.shareFolder(path: "/\(id)")
                    // Create a first post.
                    let photo = UIImage(named: "HeartFilledIcon")
                    let imageData: NSData = UIImagePNGRepresentation(photo!)!
                    self.delay(5){
                        packTagClient.files.upload(path: "/\(id)/PackTag App`Welcome to PackTag`idvinden`likes`\(NSDate())`.jpg", body: imageData).response { response, error in
                            if let errorfile = error {
                                print(errorfile)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Make a function if somewhere tapped not on keyboard.
    @IBAction func tap (sender: UITapGestureRecognizer!){
        eventId.resignFirstResponder()
        createId.resignFirstResponder()
    }
    
    // Set up dropbox popup if user clicks on button.
    @IBAction func changeUserClicked(sender: AnyObject) {
        Dropbox.unlinkClient()
        Dropbox.authorizeFromController(self)
    }
    
    // Set some labels to invisible.
    func labelsToInvisible(){
        eventNotExisting.hidden = true
        eventExisting.hidden = true
        eventMade.hidden = true
        noSpacesAllowed.hidden = true
        tooLongId.hidden = true
    }
    
    // Get folderId (Drobox function deprecated).
    func getFolderId(result: String) -> String {
        let subString = result.componentsSeparatedByString("shared_folder_id")
        let folderId = subString[1].componentsSeparatedByString("=")
        let folderId1 = folderId[1].componentsSeparatedByString(";")
        let folderId2 = folderId1[0]
        let folderId3 = folderId2.substringFromIndex(folderId2.startIndex.successor())
        
        return folderId3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
