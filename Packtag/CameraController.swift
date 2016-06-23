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
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    var selectedImage: UIImage?
    
    @IBOutlet weak var showCaptionController: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceLabel.text = "No image selected"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CameraController.clearImage), name: "clearImage", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if (selectedImage == nil){
            showCaptionController.hidden = true
        }
        else {
            showCaptionController.hidden = false
            sourceLabel.hidden = true
        }
    }
    
    func clearImage () {
        print("clearImage entered")
        selectedImageView.image = nil
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
        print("vanaf hier ")
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectPhoto"){
            let destinationVC = segue.destinationViewController as! CaptionController
            destinationVC.selectedImage = selectedImage
        }
    }
}

