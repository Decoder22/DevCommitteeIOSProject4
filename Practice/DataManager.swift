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
    private let dbm = DatabaseManager()
    
    func addEvent(event:Event, onDone:@escaping (_ err:Error?)->Void){
        dbm.addEvent(event: event) { (err) in
            if(err == nil){
                self.events.append(event)
            }
            onDone(err)
        }
    }
    func addRestaurant(rest:Restaurant, onDone:@escaping (_ err:Error?)->Void){
        dbm.addRestaurant(rest: rest) { (err) in
            if(err == nil){
                self.restaurants.append(rest)
            }
            onDone(err)
        }
    }
    
    func getRestaurantsFromDatabase(onDone:@escaping ()->Void) {
        dbm.getRestaurants { (restaurants) in
            self.restaurants = restaurants
            onDone()
        }
    }
    
    func getEventsFromDatabase(onDone:@escaping ()->Void) {
        dbm.getEvents { (events) in
            self.events = events
            onDone()
        }
    }
}

class AtomicCounter {
    private var queue:DispatchQueue
    private (set) var value: Int = 0
    
    init(identifier:String){
        queue = DispatchQueue(label: identifier)
    }
    
    func increment() {
        queue.sync {
            value += 1
        }
    }
}
