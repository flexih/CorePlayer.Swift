//
//  CPInterruption.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation

#if os(iOS)

protocol InterruptionDelegate: class {
    func interrupt(reason: CorePlayer.InterruptionReason)
}

class Interruption {
    
    weak var delegate: InterruptionDelegate?
    
    func observeInterruption(delegate: InterruptionDelegate) {
        self.delegate = delegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didInterrupt(_:)), name: AVAudioSessionInterruptionNotification, object: nil)
    }
    
    func unobserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    dynamic func didInterrupt(notification: NSNotification) {
        guard let info = notification.userInfo else { return }

        if let type = info[AVAudioSessionInterruptionTypeKey] as? AVAudioSessionInterruptionType {
            if type == .Began {
                beginInterrupt()
            } else if type == .Ended {
                if let option = info[AVAudioSessionInterruptionOptionKey] as? AVAudioSessionInterruptionOptions {
                    if option == .ShouldResume {
                        endInterrupt()
                    }
                }
            }
        }
    }

    func beginInterrupt() {
        delegate?.interrupt(.AudioSessionBegan)
    }
    
    func endInterrupt() {
        delegate?.interrupt(.AudioSessionEnd)
    }

    deinit {
        unobserver()
    }
}

#endif
