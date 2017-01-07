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
    func interrupt(_ reason: InterruptionReason)
}

class CPInterruption: NSObject {
    
    weak var delegate: CPInterruptionDelegate?
    
    func observeInterruption(_ delegate: CPInterruptionDelegate) {
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(CPInterruption.interrupt(_:)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
    }
    
    func unobserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func interrupt(_ notification: Notification) {
        if let info: NSDictionary = notification.userInfo as NSDictionary? {
            if let type: UInt = info.object(forKey: AVAudioSessionInterruptionTypeKey) as? UInt {
                if type == AVAudioSessionInterruptionType.began.rawValue {
                    beginInterrupt()
                } else if type == AVAudioSessionInterruptionType.ended.rawValue {
                    if let _: UInt = info.object(forKey: AVAudioSessionInterruptionOptionKey) as? UInt {
                        if type == AVAudioSessionInterruptionOptions.shouldResume.rawValue {
                            endInterrupt()
                        }
                    }
                }
            }
        }
    }
    
    func beginInterrupt() {
        delegate?.interrupt(.audioSessionBegan)
    }
    
    func endInterrupt() {
        delegate?.interrupt(.audioSessionEnd)
    }
}

#endif
