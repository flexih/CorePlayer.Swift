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
    case feature = 1
    case view
}

@objc public enum InterruptionReason: Int {
    case newDeviceAvailable = 1 /// earphone pulgged in
    case oldDeviceUnavailable   /// earphone pulgged out
    case audioSessionBegan      /// message alert, calendar alert, etc.
    case audioSessionEnd
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
    @objc optional func willPlay()
    
    /**
     Just played
    */
    @objc optional func startPlay()
    
    /**
     Stopped even before any URL setted
    */
    @objc optional func cancelPlay()
    
    /**
     Play ends
     -parameter state: end state, might be error, see CPState
    */
    @objc optional func endPlayCode(_ state: CPState)
    
    /**
     Each URL will notify its play state, if different handles needed
    */
    @objc optional func willSection(_ cpu: CPURL)
    @objc optional func startSection(_ cpu: CPURL)
    @objc optional func endSection(_ cpu: CPURL)
    
    @objc optional func willPend()
    @objc optional func endPend()
    
    @objc optional func willPause()
    @objc optional func endPause()
    
    @objc optional func startSeek(_ time: TimeInterval)
    @objc optional func seekTo(_ time: TimeInterval)
    @objc optional func endSeek(_ time: TimeInterval, isEnd: Bool)
    
    /**
     -parameter duration: total duration, might be 0
    */
    @objc optional func durationAvailable(_ duration: TimeInterval)
    
    /**
     -parameter duration: played duration
    */
    @objc optional func played(_ duration: TimeInterval)
    
    /**
     -parameter duration: preloaded duration
    */
    @objc optional func playable(_ duration: TimeInterval)
    
    /**
     UIApplicationWillResignActive
    */
    @objc optional func appResign()
    
    /**
     UIApplicationDidBecomeActive
    */
    @objc optional func appActive()
    
    /**
     -parameter size: presentation size
    */
    @objc optional func presentationSize(_ size: CGSize)
    
    /**
     AirPlay state changes
    */
    @objc optional func airplayShift(_ on: Bool)
    
    /**
     Interrupted by reasons, see InterruptionReason
    */
    @objc optional func interrupt(_ reason: InterruptionReason)
    
    /**
     Error happens, stop playing, see endPlayCode: too
    */
    @objc optional func error(_ err: CPError)
}
