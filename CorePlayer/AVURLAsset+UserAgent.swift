//
//  AVURLAsset+UserAgent.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation
import AVFoundation

extension AVURLAsset {
    
    convenience init(URL: NSURL, userAgent UA: String?) {
        self.init(URL: URL, options: UA.map{["User-Agent": $0]})
    }
    
}
