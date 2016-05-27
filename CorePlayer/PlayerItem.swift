//
//  CPPlayerItem.swift
//  CorePlayer
//
//  Created by flexih on 4/16/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation

extension AVPlayerItem {
    
    func URL() -> NSURL {
        return (asset as! AVURLAsset).URL
    }
    
    var Duration: NSTimeInterval {
        if status == .Unknown {
            return 0
        }
        
        let duration = CMTimeGetSeconds(asset.duration)
        
        return isfinite(duration) ? duration : 0
    }
}
