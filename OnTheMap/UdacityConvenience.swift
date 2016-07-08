//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func authenticateWithViewController(hostViewController: UIViewController, username: String, password: String, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        getSessionID(username, password: password) { (success, errorString) in
            if success {
                completionHandlerForAuth(success: success, errorString: errorString)
            } else {
                completionHandlerForAuth(success: success, errorString: errorString)
            }
        }
    }
    
    private func getSessionID(username: String, password: String, completionHandlerForSessionID: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.Constants.APIBaseURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                completionHandlerForSessionID(success: false, errorString: "There was an error with your request: '\(error)'")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode else {
                completionHandlerForSessionID(success: false, errorString: "No internet connection. Please obtain internet access")
                return
            }
            
            if statusCode == 403 {
                completionHandlerForSessionID(success: false, errorString: "Account not found or invalid credentials")
                return
            } else if !(statusCode >= 200 && statusCode <= 299) {
                completionHandlerForSessionID(success: false, errorString: "Unknown error, please try again")
                return
            }
            
            guard let data = data else {
                completionHandlerForSessionID(success: false, errorString: "No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
                } catch {
                    completionHandlerForSessionID(success: false, errorString: "Could not parse data as JSON: '\(data)'")
                    return
                }
            
            guard let account = parsedResult[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
                completionHandlerForSessionID(success: false, errorString: "Could not obtain UniqueID")
                return
            }
            
            guard let key = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                completionHandlerForSessionID(success: false, errorString: "Could not obtain key")
                return
            }
            
            self.uniqueID = key
            self.getUserData(completionHandlerForSessionID)
        }
        task.resume()
    }
    
    func getUserData(completionHanderForData: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(nil, withPathExtension: "/users/\(uniqueID!)"))
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                completionHanderForData(success: false, errorString: "There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHanderForData(success: false, errorString: "Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                completionHanderForData(success: false, errorString: "No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            var parsedResult: AnyObject
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                completionHanderForData(success: false, errorString: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let user = parsedResult[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] else {
                completionHanderForData(success: false, errorString: "Error obtaining user information")
                return
            }
            
            guard let lastName = user[UdacityClient.JSONResponseKeys.LastName] as? String else {
                completionHanderForData(success: false, errorString: "Error obtaining last name")
                return
            }
            
            guard let firstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String else {
                completionHanderForData(success: false, errorString: "Error obtaining first name")
                return
            }
            
            self.firstName = firstName
            self.lastName = lastName
            completionHanderForData(success: true, errorString: "Error with user data")
        }
        task.resume()
    }
}