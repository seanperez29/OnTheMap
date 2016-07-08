//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import MapKit

class UdacityClient: NSObject {
    
    var session = NSURLSession.sharedSession()
    var sessionID: String?
    var firstName: String?
    var lastName: String?
    var uniqueID: String?
    
    func taskForLogout(completionHandler: (success: Bool, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.Constants.APIBaseURL)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(success: false, error: NSError(domain: "taskForLogout", code: 0, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            completionHandler(success: true, error: nil)
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        return task
    }
    
    func replaceAnnotations(students: [StudentInformation], mapView: MKMapView) {
        for student in students {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(student.latitude, student.longitude)
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            mapView.addAnnotation(annotation)
        }
    }
    
    func clearAnnotations(mapView: MKMapView) {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    func displayErrorAlert(viewController: UIViewController, title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        performUIUpdatesOnMain { 
            viewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func udacityURLFromParameters(parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.URL!
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}