//
//  ToDoManager.swift
//  Packtag
//
//  Created by Emma Immink on 14-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import Foundation
import UIKit

class TodoManager {
    static let sharedInstance = TodoManager()
    
    // make sure no one can initialize TodoManager
    private init() {}
    
    // make table strings
    var userName = String()
    var path : String = ""
    var eventId : String = ""
    var userId = String()
    
    // create variables for profile
    var profileViewId = String()
    var arrayProfileId : Array<String> = []
    var lastShowedProfileId = String()
    var arrayProfilePhotoNames : Array<String> = []
    

}





