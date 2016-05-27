//
//  CPUrl.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

public struct CPURL {
    public let URL: NSURL
    public let from: Double /// play from
    public let userAgent: String? /// Custom UA
    public let HTTPHeaderFields: [String: String]? /// User-Agent, Cookie, etc
    
    public init(URL: NSURL, from: Double = 0, userAgent: String? = nil, HTTPHeaderFields: [String: String]? = nil) {
        self.URL = URL
        self.from = from
        self.userAgent = userAgent
        self.HTTPHeaderFields = HTTPHeaderFields
    }
}

