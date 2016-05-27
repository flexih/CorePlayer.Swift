//
//  CPModuleDelegate.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias UXView = UIView
#else
    import AppKit
    public typealias UXView = NSView
#endif

public enum CPState: Int {
    case None       = 0
    case AssetReady = 1
    case ItemReady  = 2
    case PlayReady  = 3
    case End        = 4
    case Failed     = 5
    case Error      = 6
    case Stop       = 7
}

public enum CPError: Int {
    case URLError = -1000
    case Error    = -1001
}

public enum ModuleType: Int {
    case Feature = 1
    case View    = 2
}

public enum InterruptionReason: Int {
    case NewDeviceAvailable   = 1 /// earphone pulgged in
    case OldDeviceUnavailable = 2   /// earphone pulgged out
    case AudioSessionBegan    = 3      /// message alert, calendar alert, etc.
    case AudioSessionEnd      = 4
}

public protocol ModuleDelegate {

    weak var moduleManager: ModuleManager? { get set }
//    weak var moduleDelegate: Feature? { get set }

    /**
     Do initializations when module added to module manager
    */
    func initModule()
    func deinitModule()
    func moduleType() -> ModuleType
    
    /**
     At least one URL setted, about to play
    */
    func willPlay()
    
    /**
     Just played
    */
    func startPlay()
    
    /**
     Stopped even before any URL setted
    */
    func cancelPlay()
    
    /**
     Play ends
     -parameter state: end state, might be error, see CPState
    */
    func endPlayCode(state: CPState)
    
    /**
     Each URL will notify its play state, if different handles needed
    */
    func willSection(cpu: CPURL)
    func startSection(cpu: CPURL)
    func endSection(cpu: CPURL)
    
    func willPend()
    func endPend()
    
    func willPause()
    func endPause()
    
    func startSeek(time: NSTimeInterval)
    func seekTo(time: NSTimeInterval)
    func endSeek(time: NSTimeInterval, isEnd: Bool)
    
    /**
     -parameter duration: total duration, might be 0
    */
    func durationAvailable(duration: NSTimeInterval)
    
    /**
     -parameter duration: played duration
    */
    func played(duration: NSTimeInterval)
    
    /**
     -parameter duration: preloaded duration
    */
    func playable(duration: NSTimeInterval)
    
    /**
     UIApplicationWillResignActive
    */
    func appResign()
    
    /**
     UIApplicationDidBecomeActive
    */
    func appActive()
    
    /**
     -parameter size: presentation size
    */
    func presentationSize(size: CGSize)
    
    /**
     AirPlay state changes
    */
    func airplayShift(on: Bool)
    
    /**
     Interrupted by reasons, see InterruptionReason
    */
    func interrupt(reason: InterruptionReason)
    
    /**
     Error happens, stop playing, see endPlayCode: too
    */
    func error(err: CPError)
}

extension ModuleDelegate {

    public func initModule() {
    }

    public func deinitModule() {
    }

    public func moduleType() -> ModuleType {
        return .Feature
    }

    public func willPlay() {
    }

    public func startPlay() {
    }

    public func cancelPlay() {
    }

    public func endPlayCode(state: CPState) {
    }

    public func willSection(cpu: CPURL) {
    }

    public func startSection(cpu: CPURL) {
    }

    public func endSection(cpu: CPURL) {
    }

    public func willPend() {
    }

    public func endPend() {
    }

    public func willPause() {
    }

    public func endPause() {
    }

    public func startSeek(time: NSTimeInterval) {
    }

    public func seekTo(time: NSTimeInterval) {
    }

    public func endSeek(time: NSTimeInterval, isEnd: Bool) {
    }

    public func durationAvailable(duration: NSTimeInterval) {
    }

    public func played(duration: NSTimeInterval) {
    }

    public func playable(duration: NSTimeInterval) {
    }

    public func appResign() {
    }

    public func appActive() {
    }

    public func presentationSize(size: CGSize) {
    }

    public func airplayShift(on: Bool) {
    }

    public func interrupt(reason: InterruptionReason) {
    }

    public func error(err: CPError) {
    }

}
