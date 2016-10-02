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
        NotificationCenter.default.addObserver(self, selector: #selector(TableViewController.reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = locations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentEntry")!
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView!.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = locations[(indexPath as NSIndexPath).row]
        
        guard let mediaURL = student.mediaURL else {
            print("No media exists")
            return
        }
        
        guard let url = URL(string: mediaURL) else {
            UdacityClient.sharedInstance().displayErrorAlert(self, title: "Could not obtain URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
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
        NotificationCenter.default.removeObserver(self)
    }
}
