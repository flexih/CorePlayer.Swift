//
//  CPPlayer.swift
//  CorePlayer
//
//  Created by flexih on 4/16/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation

class Player: AVPlayer {

    class func isRatePlaying(rate: Float) -> Bool {
        return rate > 0
    }
    
    func isPlaying() -> Bool {
        return self.dynamicType.isRatePlaying(rate)
    }
    
    func isPlayToEnd() -> Bool {
        guard let duration: CMTime = currentItem?.duration else {
            return false
        }
        
        var playedSec  = CMTimeGetSeconds(currentTime())
        var durationSec = CMTimeGetSeconds(duration)
        
        if !(isfinite(playedSec) && isfinite(durationSec)) {
            return false
        }
        
        playedSec = ceil(playedSec)
        durationSec = ceil(durationSec)
        
        return fabs(playedSec - durationSec) <= 5.0
    }
    
    func seekToTime(time: CMTime, accurate: Bool, completion: ((Bool) -> Void)?) {
        if accurate {
            seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero) {
                completion?($0)
            }
        } else {
            seekToTime(time) { completion?($0) }
        }
    }

    func CurrentTime() -> NSTimeInterval {
        let rlt = CMTimeGetSeconds(currentTime())
        return isfinite(rlt) ? rlt : 0
    }
}
