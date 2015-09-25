//
//  CPInterruption.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation

#if os(iOS)

protocol CPInterruptionDelegate: NSObjectProtocol {
    func interrupt(reason: InterruptionReason)
}

class CPInterruption: NSObject {
    
    weak var delegate: CPInterruptionDelegate?
    
    func observeInterruption(delegate: CPInterruptionDelegate) {
        self.delegate = delegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "interrupt:", name: AVAudioSessionInterruptionNotification, object: nil)
    }
    
    func unobserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func interrupt(notification: NSNotification) {
        if let info: NSDictionary = notification.userInfo {
            if let type: UInt = info.objectForKey(AVAudioSessionInterruptionTypeKey) as? UInt {
                if type == AVAudioSessionInterruptionType.Began.rawValue {
                    beginInterrupt()
                } else if type == AVAudioSessionInterruptionType.Ended.rawValue {
                    if let _: UInt = info.objectForKey(AVAudioSessionInterruptionOptionKey) as? UInt {
                        if type == AVAudioSessionInterruptionOptions.ShouldResume.rawValue {
                            endInterrupt()
                        }
                    }
                }
            }
        }
    }
    
    func beginInterrupt() {
        delegate?.interrupt(InterruptionReason.AudioSessionBegan)
    }
    
    func endInterrupt() {
        delegate?.interrupt(InterruptionReason.AudioSessionEnd)
    }
}

#endif
