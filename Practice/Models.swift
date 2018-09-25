//
//  Models.swift
//  Practice
//
//  Created by Brian Johncox on 9/25/18.
//  Copyright © 2018 TabBarPractice. All rights reserved.
//

import Foundation
import UIKit

class Event{
    var name:String
    var image: UIImage
    
    init(name:String, image:UIImage) {
        self.name = name
        self.image = image
    }
    
}

class Restaurant {
    var name:String
    init(name:String) {
        self.name = name
    }
}
