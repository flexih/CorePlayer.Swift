//
//  CPModuleDelegate.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

@objc public enum ModuleType: Int {
    case Feature = 1
    case View
}

@objc public enum InterruptionReason: Int {
    case NewDeviceAvailable = 1 /// earphone pulgged in
    case OldDeviceUnavailable   /// earphone pulgged out
    case AudioSessionBegan      /// message alert, calendar alert, etc.
    case AudioSessionEnd
}

@objc public protocol CPModuleDelegate: NSObjectProtocol {
    var moduleID: Int { get set }
    weak var moduleManager: CPModuleManager? { get set }
    weak var moduleDelegate: CorePlayerFeature? { get set }
    
    /**
     Do initializations when module added to module manager
    */
    func initModule()
    func deinitModule()
    func moduleType() -> ModuleType
    
    /**
     At least one URL setted, about to play
    */
    optional func willPlay()
    
    /**
     Just played
    */
    optional func startPlay()
    
    /**
     Stopped even before any URL setted
    */
    optional func cancelPlay()
    
    /**
     Play ends
     -parameter state: end state, might be error, see CPState
    */
    optional func endPlayCode(state: CPState)
    
    /**
     Each URL will notify its play state, if different handles needed
    */
    optional func willSection(cpu: CPURL)
    optional func startSection(cpu: CPURL)
    optional func endSection(cpu: CPURL)
    
    optional func willPend()
    optional func endPend()
    
    optional func willPause()
    optional func endPause()
    
    optional func startSeek(time: NSTimeInterval)
    optional func seekTo(time: NSTimeInterval)
    optional func endSeek(time: NSTimeInterval, isEnd: Bool)
    
    /**
     -parameter duration: total duration, might be 0
    */
    optional func durationAvailable(duration: NSTimeInterval)
    
    /**
     -parameter duration: played duration
    */
    optional func played(duration: NSTimeInterval)
    
    /**
     -parameter duration: preloaded duration
    */
    optional func playable(duration: NSTimeInterval)
    
    /**
     UIApplicationWillResignActive
    */
    optional func appResign()
    
    /**
     UIApplicationDidBecomeActive
    */
    optional func appActive()
    
    /**
     -parameter size: presentation size
    */
    optional func presentationSize(size: CGSize)
    
    /**
     AirPlay state changes
    */
    optional func airplayShift(on: Bool)
    
    /**
     Interrupted by reasons, see InterruptionReason
    */
    optional func interrupt(reason: InterruptionReason)
    
    /**
     Error happens, stop playing, see endPlayCode: too
    */
    optional func error(err: CPError)
}
