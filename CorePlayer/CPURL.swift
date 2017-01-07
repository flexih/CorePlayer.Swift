//
//  CPUrl.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

open class CPURL: NSObject {
    open var URL: Foundation.URL!
    open var UA: String? /// Custom UA
    open var from: Double = 0 /// When to play from
    open var HTTPHeaderFields: [String: String]? /// User-Agent, Cookie, etc
    
    public init(URL: Foundation.URL!, from: Double) {
        self.URL = URL
        self.from = from
    }
    
    public convenience init(URL: Foundation.URL!) {
        self.init(URL: URL, from: 0)
    }
}

