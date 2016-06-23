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
    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage!
    
    
    @IBAction func submitPressed (sender: UIButton){
        
        if (captionText.text!.characters.count >= 21){
            captionText.text! = captionText.text!.substringToIndex(captionText.text!.startIndex.advancedBy(20))
        }
        
        let imageData: NSData = UIImagePNGRepresentation(selectedImage!)!
        
        if let client = Dropbox.authorizedClient {
            print("komt tie hierin dan")
            
            client.files.upload(path: "\(TodoManager.sharedInstance.path)/\(TodoManager.sharedInstance.userName)`\(captionText.text!)`\(TodoManager.sharedInstance.userId)`likes`version`.jpg", body: imageData).response { response, error in
                if let metadata = response {
                    print("*** Upload file ****")
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                }
                if let errorfile = error {
                    print(errorfile)
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
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        let currentCharacterCount = textField.text?.characters.count ?? 0
//        if (range.length + range.location > currentCharacterCount){
//            return false
//        }
//        let newLength = currentCharacterCount + string.characters.count - range.length
//        return newLength <= 25
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreview.image = selectedImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
}

