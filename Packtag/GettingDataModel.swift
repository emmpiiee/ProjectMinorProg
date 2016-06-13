//
//  GettingDataModel.swift
//  Packtag
//
//  Created by Emma Immink on 13-06-16.
//  Copyright © 2016 Emma Immink. All rights reserved.
//

import UIKit

// Create class Profile to store variables for profiles
class GettingData {
    var filenames:Array<String>
    var picture:Array<UIImage?>
    
    // initialize Profile class
    init(filenames:Array<String>, var picture:Array<UIImage?>){
        self.filenames = filenames
        self.picture = picture
    }
}