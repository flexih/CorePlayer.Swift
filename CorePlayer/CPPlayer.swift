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
    
    func listenAirPlayState(_ observer: NSObject) -> Bool {
        let key = airPlayObserverKey()
        
        if key == magicKey {
            return false
        }
        
        addObserver(observer, forKeyPath: key, options: [.old, .new], context: nil)
        
        return true
    }
    
    func unlistenAirPlayState(_ observer: NSObject) {
        let key = airPlayObserverKey()
        
        removeObserver(observer, forKeyPath: key)
    }
    
    #endif
    
    class func isRatePlaying(_ rate: Float) -> Bool {
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
        
        if !(played_sec.isFinite && duration_sec.isFinite) {
            return false
        }
        
        played_sec = ceil(played_sec)
        duration_sec = ceil(duration_sec)
        
        return fabs(played_sec - duration_sec) <= 5.0
    }
    
    func seekToTime(_ time: CMTime, accurate: Bool, completion: ((Bool) -> Void)?) {
        if completion != nil {
            if accurate {
                seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: completion!)
            } else {
                seek(to: time, completionHandler: completion!)
            }
        } else {
            seek(to: time)
        }
    }
    
    func ccurrentTime() -> TimeInterval {
        let rlt = CMTimeGetSeconds(currentTime())
        return rlt.isFinite ? rlt : 0
    }
}
