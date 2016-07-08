//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/30/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var locations = [StudentInformation]()
    @IBOutlet var studentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewController.reloadData), name: "reloadData", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ParseClient.sharedInstance().getStudentLocations { (students, success, errorString) in
            if let students = students {
                self.locations = students
                performUIUpdatesOnMain({
                    self.studentTableView.reloadData()
                })
            } else {
                UdacityClient.sharedInstance().displayErrorAlert(self, title: "Could not access student locations")
                print(errorString)
            }
        }
    }
}

extension TableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let student = locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("studentEntry")!
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView!.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = locations[indexPath.row]
        
        guard let url = NSURL(string: student.mediaURL) else {
            UdacityClient.sharedInstance().displayErrorAlert(self, title: "Could not obtain URL")
            return
        }
        
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func reloadData() {
        ParseClient.sharedInstance().getStudentLocations { (students, success, errorString) in
            if let students = students {
                self.locations = students
                performUIUpdatesOnMain({ 
                    self.studentTableView.reloadData()
                })
            }
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
