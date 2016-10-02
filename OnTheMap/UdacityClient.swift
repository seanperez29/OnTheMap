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
    
    var session = URLSession.shared
    var sessionID: String?
    var firstName: String?
    var lastName: String?
    var uniqueID: String?
    
    func taskForLogout(_ completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let request = NSMutableURLRequest(url: URL(string: UdacityClient.Constants.APIBaseURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(false, NSError(domain: "taskForLogout", code: 0, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            completionHandler(true, nil)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue))
        }
        task.resume()
    }
    
    func replaceAnnotations(_ students: [StudentInformation], mapView: MKMapView) {
        for student in students {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(student.latitude!, student.longitude!)
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            mapView.addAnnotation(annotation)
        }
    }
    
    func clearAnnotations(_ mapView: MKMapView) {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    func displayErrorAlert(_ viewController: UIViewController, title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        performUIUpdatesOnMain { 
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func udacityURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
