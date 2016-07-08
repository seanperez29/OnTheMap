//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Sean Perez on 7/2/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session = NSURLSession.sharedSession()

    func taskForPostMethod(methodParameters: [String:AnyObject], completionHandler: (success: Bool, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Constants.BaseURL)!)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(methodParameters, options: .PrettyPrinted)
        } catch {
            completionHandler(success: false, error: NSError(domain: "taskForPostMethod", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error with student post"]))
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(success: false, error: NSError(domain: "taskForPostMethod", code: 0, userInfo: userInfo))
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
            completionHandler(success: true, error: nil)
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        return task
    }
    
    func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.URL!
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}