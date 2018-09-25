//
//  AddNewEventViewController.swift
//  Practice
//
//  Created by Brian Johncox on 9/25/18.
//  Copyright © 2018 TabBarPractice. All rights reserved.
//

import UIKit

class AddNewEventViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameField: UITextField!
    
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1

        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.accessibilityActivate()
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    

    
    @IBAction func addEvent(_ sender: Any) {
        guard let image = imageView.image else{
            notify(title: "Failure", subtitle: "Please include an image")
            return
        }
        guard let text = nameField.text, !text.isEmpty else{
            notify(title: "Failure", subtitle: "No name entered")
            return
        }
        
        let ev = Event(name: nameField.text!, image: image)
        DataManager.sharedInstance.events.append(ev)
        
        nameField.text = ""
        imageView.image = nil
        self.notify(title: "Success", subtitle: "Event was created")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func notify(title:String, subtitle: String, completion: ((UIAlertAction)->Void)? = nil){
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: completion) //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
