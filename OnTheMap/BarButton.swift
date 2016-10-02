//
//  BarButton.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

class BarButton: UITabBarController {
    
    
    @IBAction func userPostPressed(_ sender: AnyObject) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "UserPostViewController") as! UserPostViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        UdacityClient.sharedInstance().taskForLogout { (success, error) in
            if error != nil {
                print(error)
            }
        }
    }
    
    @IBAction func reload(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
    }
}
