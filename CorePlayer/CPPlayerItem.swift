//
//  CPPlayerItem.swift
//  CorePlayer
//
//  Created by flexih on 4/16/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation
import AVFoundation

class CPPlayerItem: AVPlayerItem {
    
    func URL() -> Foundation.URL {
        return (asset as! AVURLAsset).url
    }
    
    func cduration() -> TimeInterval {
        if status == .unknown {
            return 0
        }
        
        let duration = CMTimeGetSeconds(asset.duration)
        
        return duration.isFinite ? duration : 0
    }
}
