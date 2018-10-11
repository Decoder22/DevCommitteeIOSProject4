//
//  AddRestaurantViewController.swift
//  Practice
//
//  Created by Brian Johncox on 9/25/18.
//  Copyright © 2018 TabBarPractice. All rights reserved.
//

import UIKit

class AddRestaurantViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

    @IBAction func addEvent(_ sender: Any) {
        let rest = Restaurant(name: nameField.text!)
        DataManager.sharedInstance.addRestaurant(rest: rest) { (err) in
            self.nameField.text = ""
        }
    }
    

}
