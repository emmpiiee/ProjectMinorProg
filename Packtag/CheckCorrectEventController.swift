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
        checkEvent.text = "Wait untill your event is loaded.."
        eventId.setTitle("\(TodoManager.sharedInstance.path)", forState: .Normal)
        eventId.hidden = true
        delay(15){
            self.checkEvent.hidden = true
            self.eventId.hidden = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        Post.feed?.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay: Double, closure: ()->()){
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
}