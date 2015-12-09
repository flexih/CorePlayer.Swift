//
//  CPUrl.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

public class CPURL: NSObject {
    public var URL: NSURL!
    public var UA: String?
    public var from: Double = 0
    
    public init(URL: NSURL!, from: Double) {
        self.URL = URL
        self.from = from
    }
    
    public convenience init(URL: NSURL!) {
        self.init(URL: URL, from: 0)
    }
}

