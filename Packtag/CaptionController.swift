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
        let newPost = Post.init(creator: Profile.currentUser!.username, image: selectedImage, caption: captionText.text)
        Post.feed!.append(newPost)
        Profile.currentUser!.posts.append(newPost)
        
        NSNotificationCenter.defaultCenter().postNotificationName("clearImage", object: nil)
        
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
    
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreview.image = selectedImage
    }
    
    
}
