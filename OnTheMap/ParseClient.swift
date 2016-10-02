//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Sean Perez on 7/2/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session = URLSession.shared

    func taskForPostMethod(_ methodParameters: [String:AnyObject], completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let request = NSMutableURLRequest(url: URL(string: ParseClient.Constants.BaseURL)!)
        request.httpMethod = "POST"
        request.addValue(ParseClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ParseRestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: methodParameters, options: .prettyPrinted)
        } catch {
            completionHandler(false, NSError(domain: "taskForPostMethod", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error with student post"]))
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(false, NSError(domain: "taskForPostMethod", code: 0, userInfo: userInfo))
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
            completionHandler(true, nil)
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
        }
        task.resume()
    }
    
    func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
