//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        static let APIBaseURL = "https://www.udacity.com/api/session"
        static let UdacitySignupURL = "https://www.udacity.com/account/auth#!/signup"
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let POST = "POST"
        static let DELETE = "DELETE"
    }
    
    struct URLKeys {
        static let sessionID = "id"
    }
    
    struct JSONResponseKeys {
        static let Account = "account"
        static let Key = "key"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Results = "results"
    }
    
    struct JSONRequestKeys {
        static let Limit = "limit"
    }
    
    struct JSONRequestValues {
        static let Limit100 = "100"
    }
}