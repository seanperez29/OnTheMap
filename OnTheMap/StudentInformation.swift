//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/29/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    
    let firstName: String
    let lastName: String
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let mapString: String
    
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        longitude = dictionary["longitude"] as! CLLocationDegrees
        latitude = dictionary["latitude"] as! CLLocationDegrees
        mediaURL = dictionary["mediaURL"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        objectId = dictionary["objectId"] as! String
        mapString = dictionary["mapString"] as! String
     }
    
    static func studentLocationFromResults(results: [[String:AnyObject]]) -> [StudentInformation] {
        var studentInformation = [StudentInformation]()
        for result in results {
            studentInformation.append(StudentInformation(dictionary: result))
        }
        return studentInformation
    }
}