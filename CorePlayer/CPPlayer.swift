//
//  CPPlayer.swift
//  CorePlayer
//
//  Created by flexih on 4/16/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import Foundation
import AVFoundation

let magicKey = "#magic#"

class CPPlayer: AVPlayer {
    
    #if os(iOS)
    
    func airPlayObserverKey() -> String {
        return "externalPlaybackActive"
    }
    
    func listenAirPlayState(observer: NSObject) -> Bool {
        let key = airPlayObserverKey()
        
        if key == magicKey {
            return false
        }
        
        addObserver(observer, forKeyPath: key, options: [.Old, .New], context: nil)
        
        return true
    }
    
    func unlistenAirPlayState(observer: NSObject) {
        let key = airPlayObserverKey()
        
        removeObserver(observer, forKeyPath: key)
    }
    
    #endif
    
    class func isRatePlaying(rate: Float) -> Bool {
        return rate > 0
    }
    
    func isPlaying() -> Bool {
        return CPPlayer.isRatePlaying(rate)
    }
    
    func isPlayToEnd() -> Bool {
        let played: CMTime = currentTime()
        guard let duration: CMTime = currentItem?.duration else {
            return false
        }
        
        var played_sec: Float64  = CMTimeGetSeconds(played)
        var duration_sec: Float64  = CMTimeGetSeconds(duration)
        
        if !(isfinite(played_sec) && isfinite(duration_sec)) {
            return false
        }
        
        played_sec = ceil(played_sec)
        duration_sec = ceil(duration_sec)
        
        return fabs(played_sec - duration_sec) <= 5.0
    }
    
    func seekToTime(time: CMTime, accurate: Bool, completion: ((Bool) -> Void)?) {
        if completion != nil {
            if accurate {
                seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: completion!)
            } else {
                seekToTime(time, completionHandler: completion!)
            }
        } else {
            seekToTime(time)
        }
    }
    
    func ccurrentTime() -> NSTimeInterval {
        let rlt = CMTimeGetSeconds(currentTime())
        return isfinite(rlt) ? rlt : 0
    }
}