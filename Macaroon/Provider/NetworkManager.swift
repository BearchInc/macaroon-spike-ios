//
//  NetworkManager.swift
//  Macaroon
//
//  Created by Lisardo on 11/3/15.
//  Copyright © 2015 bearch. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

class NetworkManager {
    
    var manager: Manager?
    var cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    init() {

        configuration.HTTPCookieStorage = cookieJar
        configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        configuration.HTTPMaximumConnectionsPerHost = 10
        manager = Alamofire.Manager(configuration: configuration)
    }
}