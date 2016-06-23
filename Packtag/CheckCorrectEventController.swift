//
//  CheckCorrectEvent.swift
//  Packtag
//
//  Created by Emma Immink on 22-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//


import UIKit
import SwiftyDropbox

class CheckCorrectEventController: UIViewController {
    
    @IBOutlet weak var checkEvent: UILabel!
    @IBOutlet weak var eventId: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEvent.text = "This is the event you've chosen \(TodoManager.sharedInstance.path)"
        eventId.titleLabel?.text =  (TodoManager.sharedInstance.path)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}