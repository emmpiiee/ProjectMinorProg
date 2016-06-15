//
//  CaptionController.swift
//  Packtag
//
//  Created by Emma Immink on 09-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import SwiftyDropbox

class CaptionController: UIViewController {
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    var selectedImage: UIImage!
    
    @IBAction func submitPressed (sender: UIButton){
        let newPost = Post.init(creator: Profile.currentUser!.username, image: selectedImage, caption: captionText.text)
        Post.feed!.append(newPost)
        Profile.currentUser!.posts.append(newPost)
        
        
                    let imageData: NSData = UIImagePNGRepresentation(selectedImage!)!
                    UIImage(data:imageData,scale:1.0)
        
                    if let client = Dropbox.authorizedClient {
                    client.files.upload(path: "/\(TodoManager.sharedInstance.userName)`\(captionText.text)`likes`version`.jpg", body: imageData).response { response, error in
                        if let metadata = response {
                            print("*** Upload file ****")
                            print("Uploaded file name: \(metadata.name)")
                            print("Uploaded file revision: \(metadata.rev)")
                        }
                    }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("clearImage", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
        
        let tabBarController = self.presentingViewController as? UITabBarController
        tabBarController!.selectedIndex = 0
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backButtonPressed (sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tap (sender: UITapGestureRecognizer!){
        captionText.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreview.image = selectedImage
    }
    
    
}

//        let newPost = Post.init(creator: TodoManager.sharedInstance.userName, image: selectedImage, caption: captionText.text)
//        
//        Post.feed!.append(newPost)
//        Profile.currentUser!.posts.append(newPost)
//        NSNotificationCenter.defaultCenter().postNotificationName("clearImage", object: nil)
//        NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
//        
//        if let client = Dropbox.authorizedClient {
//            
//         
//            // upload file
//            let fileData = "Hello!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//            client.files.upload(path: "/hello.txt", body: fileData!).response { response, error in
//                if let metadata = response {
//                    print("*** Upload file ****")
//                    print("Uploaded file name: \(metadata.name)")
//                    print("Uploaded file revision: \(metadata.rev)")
//                }
//            }
////
////            let imageData: NSData = UIImagePNGRepresentation(selectedImage!)!
////            UIImage(data:imageData,scale:1.0)
////            
////            client.files.upload(path: "/hello.jpg", body: imageData).response { response, error in
////                if let metadata = response {
////                    print("*** Upload file ****")
////                    print("Uploaded file name: \(metadata.name)")
////                    print("Uploaded file revision: \(metadata.rev)")
////                }
////            }
//
//    }
//        
//        let tabBarController = self.presentingViewController as? UITabBarController
//        tabBarController!.selectedIndex = 0
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    @IBAction func backButtonPressed (sender: UIButton){
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    @IBAction func tap (sender: UITapGestureRecognizer!){
//        captionText.resignFirstResponder()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imagePreview.image = selectedImage
//    }
//}
