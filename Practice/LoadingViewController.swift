//
//  LoadingViewController.swift
//  Practice
//
//  Created by Brian Johncox on 10/10/18.
//  Copyright © 2018 TabBarPractice. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let counter = AtomicCounter(identifier: "initializer")
        
        DataManager.sharedInstance.getEventsFromDatabase {
            counter.increment()
            if(counter.value == 2){
                self.finished()
            }
        }
        DataManager.sharedInstance.getRestaurantsFromDatabase{
            counter.increment()
            if(counter.value == 2){
                self.finished()
            }
        }
        
    }
    
    func finished(){
        self.performSegue(withIdentifier: "FinishLoading", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
