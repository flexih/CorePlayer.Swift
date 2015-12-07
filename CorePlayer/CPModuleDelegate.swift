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
    case NewDeviceAvailable = 1
    case OldDeviceUnavailable
    case AudioSessionBegan
    case AudioSessionEnd
}

@objc public protocol CPModuleDelegate: NSObjectProtocol {
    var moduleID: Int { get set }
    weak var moduleManager: CPModuleManager? { get set }
    weak var moduleDelegate: CorePlayerFeature? { get set }
    
    func initModule()
    func deinitModule()
    func moduleType() -> ModuleType
    
    optional func willPlay()
    optional func startPlay()
    optional func cancelPlay()
    optional func endPlayCode(state: CPState)
    
    optional func willSection(cpu: CPUrl)
    optional func startSection(cpu: CPUrl)
    optional func endSection(cpu: CPUrl)
    
    optional func willPend()
    optional func endPend()
    optional func willPause()
    optional func endPause()
    
    optional func startSeek(time: NSTimeInterval)
    optional func seekTo(time: NSTimeInterval)
    optional func endSeek(time: NSTimeInterval, isEnd: Bool)
    
    optional func durationAvailable(duration: NSTimeInterval)
    optional func played(duration: NSTimeInterval)
    optional func playable(duration: NSTimeInterval)
    
    optional func appResign()
    optional func appActive()
    
    optional func presentationSize(size: CGSize)
    optional func airplayShift(on: Bool)
    optional func interrupt(reason: InterruptionReason)
    optional func error(err: Int)/*CPError*/
}
