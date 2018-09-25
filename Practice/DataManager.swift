//
//  DataManager.swift
//  Practice
//
//  Created by Brian Johncox on 9/25/18.
//  Copyright © 2018 TabBarPractice. All rights reserved.
//

import Foundation

class DataManager {
    
    public static var sharedInstance = DataManager()
    
    var events = [Event]()
    var restaurants = [Restaurant]()
}
