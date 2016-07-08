//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Sean Perez on 7/2/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let methodParameters: [String:AnyObject] = [ParseClient.JSONParameterKeys.uniqueKey: uniqueKey, ParseClient.JSONParameterKeys.firstName: firstName, ParseClient.JSONParameterKeys.lastName: lastName, ParseClient.JSONParameterKeys.mapString: mapString, ParseClient.JSONParameterKeys.mediaURL: mediaURL, ParseClient.JSONParameterKeys.latitude: latitude, ParseClient.JSONParameterKeys.longitude: longitude]
        
        taskForPostMethod(methodParameters) { (success, error) in
            if success {
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "There appears to have been an error: \(error)")
            }
        }
    }
    
    func getStudentLocations(completionHandler: (students: [StudentInformation]?, success: Bool, errorString: String?) -> Void) {
        
        let requestParameters = [UdacityClient.JSONRequestKeys.Limit: UdacityClient.JSONRequestValues.Limit100]
        let request = NSMutableURLRequest(URL: parseURLFromParameters(requestParameters, withPathExtension: nil))
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                completionHandler(students: nil, success: false, errorString: "There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandler(students: nil, success: false, errorString: "Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                completionHandler(students: nil, success: false, errorString: "No data was returned by the request!")
                return
            }
            
            var parsedResult: AnyObject
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print(error)
                return
            }
            
            let results = parsedResult[UdacityClient.JSONResponseKeys.Results] as! [[String:AnyObject]]
            let students = StudentInformation.studentLocationFromResults(results)
            completionHandler(students: students, success: true, errorString: nil)
        }
        task.resume()
    }
    
}