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
    // Create outlets and variables.
    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage!
    
    // If submitPressed upload photos to dropbox and return to feed.
    @IBAction func submitPressed (sender: UIButton){
        // If caption text is longer then 30 characters use only first 30
        if (captionText.text!.characters.count >= 30){
            captionText.text! = captionText.text!.substringToIndex(captionText.text!.startIndex.advancedBy(30))
        }
        // Convert to NSDAta.
        let imageData: NSData = UIImagePNGRepresentation(selectedImage!)!
        if let client = Dropbox.authorizedClient {
            // Create post with in name all information and a timestamp.
            client.files.upload(path: "\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userName)`\(captionText.text!)`\(TodoManager.sharedInstance.userId)`likes`\(NSDate())`.jpg", body: imageData).response { response, error in
                if let errorfile = error {
                    print(errorfile)
                }
            }
        }
        // Clears image at cameracontroller and goes back to feedController.
        NSNotificationCenter.defaultCenter().postNotificationName("clearImage", object: nil)
        let tabBarController = self.presentingViewController as? UITabBarController
        tabBarController!.selectedIndex = 0
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // If backButtonPressed dismiss current viewcontroller.
    @IBAction func backButtonPressed (sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // If not on keyboard tapped, dismiss keyboard.
    @IBAction func tap (sender: UITapGestureRecognizer!){
        captionText.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreview.image = selectedImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
}

