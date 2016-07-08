//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Sean Perez on 7/2/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        static let BaseURL = "https://api.parse.com/1/classes/StudentLocation"
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes/StudentLocation"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct JSONParameterKeys {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }

}