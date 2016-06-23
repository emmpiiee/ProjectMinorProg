//
//  RegisterController.swift
//  Packtag
//
//  Created by Emma Immink on 16-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import SwiftyDropbox

class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Create outlets and variables.
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var ChangeButton: UIButton!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Controller to pick item from library or make photo.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.selectedImageView.image = selectedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Show screen and take photo if button is clicked.
    @IBAction func takePhoto(sender: UIButton!){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .Camera
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    // Show screen and pick photo if button is clicked.
    @IBAction func selectPhoto(sender: UIButton!){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    // Reload table if camera stopped.
    @IBAction func stopCamera(sender: UIButton!){
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
    }
    
    // If button clicked change profile picture and delete old one.
    @IBAction func chooseProfile(sender: UIButton!){
        // Don't continue if selected image is nil.
        if (selectedImage == nil){
        }
        else {
            if(TodoManager.sharedInstance.arrayProfilePhotoNames.contains("\(TodoManager.sharedInstance.userId)`.jpg")){
                // Delete old photo.
                if let client = Dropbox.authorizedClient {
                    client.files.delete(path: "\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userId)`.jpg")
                }
            }
            // Set selected image to NSdata
            let imageData: NSData = UIImagePNGRepresentation(self.selectedImage!)!
            if let client = Dropbox.authorizedClient {
                client.files.upload(path: "\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userId)`.jpg", body: imageData).response { response, error in
                }
            }
            // Reload profile and return to profile.
            navigationController?.popViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadProfile", object: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectPhoto"){
            let destinationVC = segue.destinationViewController as! CaptionController
            destinationVC.selectedImage = selectedImage
        }
    }
}