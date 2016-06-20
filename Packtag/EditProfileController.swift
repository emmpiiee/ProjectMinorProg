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
    @IBOutlet weak var selectedImageView: UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.selectedImageView.image = selectedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePhoto(sender: UIButton!){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .Camera
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    @IBAction func selectPhoto(sender: UIButton!){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func stopCamera(sender: UIButton!){
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
    }
    
    @IBAction func chooseProfile(sender: UIButton!){
        if (selectedImage == nil){
            print("no selectedImage")
        }
        else {
            let imageData: NSData = UIImagePNGRepresentation(selectedImage!)!
            UIImage(data:imageData,scale:1.0)
            if let client = Dropbox.authorizedClient {
                client.files.upload(path: "\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userName)`\(TodoManager.sharedInstance.userId)`version`.jpg", body: imageData).response { response, error in
                    if let metadata = response {
                        print("*** Upload file ****")
                        print("Uploaded file name: \(metadata.name)")
                        print("Uploaded file revision: \(metadata.rev)")
                    }
                }
            }
            
        
        let tabBarController = self.presentingViewController as? UITabBarController
        tabBarController!.selectedIndex = 0
        self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectPhoto"){
            let destinationVC = segue.destinationViewController as! CaptionController
            destinationVC.selectedImage = selectedImage
        }
    }

    
}