//
//  BarButton.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

class BarButton: UITabBarController {
    
    
    @IBAction func userPostPressed(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("UserPostViewController") as! UserPostViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        UdacityClient.sharedInstance().taskForLogout { (success, error) in
            if error != nil {
                print(error)
            }
        }
    }
    
    @IBAction func reload(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: nil)
    }
}
