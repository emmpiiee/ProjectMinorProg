//
//  CaptionController.swift
//  Packtag
//
//  Created by Emma Immink on 09-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit

class CaptionController: UIViewController {
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBAction func submitPressed (sender: UIButton){
        print("share photo")
    }
    
    @IBAction func backButtonPressed (sender: UIButton){
        print("back button pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreview.image = selectedImage
    }
}
