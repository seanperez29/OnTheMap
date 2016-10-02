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
    
    func authenticateWithViewController(_ hostViewController: UIViewController, username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getSessionID(username, password: password) { (success, errorString) in
            if success {
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    fileprivate func getSessionID(_ username: String, password: String, completionHandlerForSessionID: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: UdacityClient.Constants.APIBaseURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForSessionID(false, "There was an error with your request: '\(error)'")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completionHandlerForSessionID(false, "No internet connection. Please obtain internet access")
                return
            }
            
            if statusCode == 403 {
                completionHandlerForSessionID(false, "Account not found or invalid credentials")
                return
            } else if !(statusCode >= 200 && statusCode <= 299) {
                completionHandlerForSessionID(false, "Unknown error, please try again")
                return
            }
            
            guard let data = data else {
                completionHandlerForSessionID(false, "No data was returned by the request!")
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary
                } catch {
                    completionHandlerForSessionID(false, "Could not parse data as JSON: '\(data)'")
                    return
                }
            
            guard let account = parsedResult[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] else {
                completionHandlerForSessionID(false, "Could not obtain UniqueID")
                return
            }
            
            guard let key = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                completionHandlerForSessionID(false, "Could not obtain key")
                return
            }
            
            self.uniqueID = key
            self.getUserData(completionHandlerForSessionID)
        }
        task.resume()
    }
    
    func getUserData(_ completionHanderForData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(nil, withPathExtension: "/users/\(uniqueID!)"))
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                completionHanderForData(false, "There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                completionHanderForData(false, "Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                completionHanderForData(false, "No data was returned by the request!")
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            var parsedResult: AnyObject
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                completionHanderForData(false, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let user = parsedResult[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] else {
                completionHanderForData(false, "Error obtaining user information")
                return
            }
            
            guard let lastName = user[UdacityClient.JSONResponseKeys.LastName] as? String else {
                completionHanderForData(false, "Error obtaining last name")
                return
            }
            
            guard let firstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String else {
                completionHanderForData(false, "Error obtaining first name")
                return
            }
            
            self.firstName = firstName
            self.lastName = lastName
            completionHanderForData(true, "Error with user data")
        }
        task.resume()
    }
}
