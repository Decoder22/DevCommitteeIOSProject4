//
//  DatabaseHandler.swift
//  Practice
//
//  Created by Brian Johncox on 10/9/18.
//  Copyright © 2018 TabBarPractice. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    
    let db: Firestore
    
    let storage: Storage
    
    init(){
        db = Firestore.firestore()
        storage = Storage.storage()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getRestaurants(onDone:@escaping ([Restaurant])->Void) {
        self.db.collection("Restaurants").getDocuments() { (querySnapshot, err) in
            var restaurants = [Restaurant]()
            if let err = err {
                print("Error getting documents: \(err)")
                onDone(restaurants)
            } else {
                for restDocument in querySnapshot!.documents
                {
                    let name = restDocument.data()["Name"] as! String
                    restaurants.append(Restaurant(name: name))
                }
                onDone(restaurants)
            }
        }
    }
    
    func getEvents(onDone:@escaping ([Event])->Void) {
        // A
        self.db.collection("Events").getDocuments() { (querySnapshot, err) in
            var events = [Event]()
            if let err = err {
                print("Error getting documents: \(err)")
                onDone(events)
            } else {
                // B
                let counter = AtomicCounter(identifier: "imageDownload")
                for eventDocument in querySnapshot!.documents
                {
                    //C
                    let name = eventDocument.data()["Name"] as! String
                    let imageName = eventDocument.data()["ImageName"] as! String
                    //D
                    self.retrievePictureFromFilename(filename: imageName, onDone: { (image) in
                        events.append(Event(name: name, image: image))
                        //E
                        counter.increment()
                        if(counter.value == querySnapshot!.documents.count){
                            onDone(events)
                        }
                    })
                    
                }
            }
        }
    }
    
    //This method will handle the downloading the file from the database
    func retrievePictureFromFilename(filename:String,onDone:@escaping ( _ image:UIImage) ->Void ){
        let pathReference = storage.reference(withPath: filename)
        // Download in memory with a maximum allowed size of 1MB (20 * 1024 * 1024 bytes)
        // Apparently the stock images on ios are at least 10 MB..... Yikes
        pathReference.getData(maxSize: 11 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR IN PICTURE"+error.localizedDescription)
            } else {
                // Data for filename is returned
                onDone(UIImage(data: data!)!)
            }
        }
    }
    
    func addRestaurant(rest:Restaurant, onDone:@escaping (_ err:Error?)->Void){
            // write the document to the HOUSE table and save the reference
            self.db.collection("Restaurants").addDocument(
                data: [
                "Name" : rest.name
                ]
            ){ err in
                onDone(err)
            }
        
    }
    
    func addEvent(event:Event, onDone:@escaping (_ err:Error?)->Void){
        // write the document to the HOUSE table and save the reference
        // A
        let filename = event.name+".png"
        uploadImageWithFilename(filename: filename, img: event.image) { (err) in
            // B
            self.db.collection("Events").addDocument(
                //C
                data: [
                    "Name" : event.name,
                    "ImageName": filename
                ]
                //D
            ){ err in
                onDone(err)
            }
        }
        
        
    }
    
    func uploadImageWithFilename(filename:String,img:UIImage, onDone:@escaping (_ err:Error?)->Void){
        let ref = self.storage.reference().child(filename)
        ref.putData(img.pngData()!, metadata: nil) { (storage, error) in
            onDone(error)
        }
    }
}
