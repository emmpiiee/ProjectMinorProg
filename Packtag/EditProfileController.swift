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
    @IBOutlet weak var ChangeButton: UIButton!
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
            if(TodoManager.sharedInstance.arrayProfilePhotoNames.contains("\(TodoManager.sharedInstance.userId)`.jpg")){
                print("je hebt al profile pciture")
                if let client = Dropbox.authorizedClient {
                    print("kom je hier een keer in")
                    client.files.delete(path: "\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userId)`.jpg")
                    print("\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userId)`.jpg")
                    print("\(TodoManager.sharedInstance.userId)`.jpg")
                }
            }
            let imageData: NSData = UIImagePNGRepresentation(self.selectedImage!)!
            UIImage(data:imageData,scale:1.0)
            if let client = Dropbox.authorizedClient {
                client.files.upload(path: "\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userId)`.jpg", body: imageData).response { response, error in
                    if let metadata = response {
                        print("*** Upload file ****")
                        print("Uploaded file name: \(metadata.name)")
                        print("Uploaded file revision: \(metadata.rev)")
                    }
                }
            }
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