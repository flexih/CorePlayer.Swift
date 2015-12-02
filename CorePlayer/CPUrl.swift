//
//  CPUrl.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation

public class CPUrl: NSObject {
    public var url: NSURL!
    public var ua: String?
    public var from: Double = 0
    
    init!(url: NSURL!, from: Double) {
        self.url = url
        self.from = from
    }
    
    convenience init!(url: NSURL!) {
        self.init(url: url, from: 0)
    }
}

