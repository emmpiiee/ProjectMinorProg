//
//  CameraController.swift
//  Packtag
//
//  Created by Emma Immink on 08-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit
import UIKit

class CameraController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Create outlets and variable.
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var showCaptionController: UIButton!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceLabel.text = "No image selected"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CameraController.clearImage), name: "clearImage", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // If no image selected no option to go futher.
        if (selectedImage == nil){
            showCaptionController.hidden = true
        }
        else {
            showCaptionController.hidden = false
            sourceLabel.hidden = true
        }
    }
    
    // Function to clear image.
    func clearImage () {
        selectedImageView.image = nil
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
    
    // Give captionController the picked photo.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectPhoto"){
            let destinationVC = segue.destinationViewController as! CaptionController
            destinationVC.selectedImage = selectedImage
        }
    }
}

