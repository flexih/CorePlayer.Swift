//
//  CorePlayerFeature.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation

@objc public enum CPState: Int {
    case none
    case assetReady
    case itemReady
    case playReady
    case end
    case failed
    case error
    case stop
}

@objc public enum CPError: Int {
    case urlError = -1000
    case error
}

@objc public protocol CorePlayerFeature: NSObjectProtocol {
    
    var scaleFill: Bool { get set }
    #if os(iOS)
    var allowAirPlay: Bool { get set }
    #endif
    
    func playURL(_ URL: URL)
    func playURLs(_ cpus: Array<CPURL>)
    func appendURLs(_ cpus: Array<CPURL>)
    func appendURL(_ URL: URL)
    
    func avplayer() -> AVPlayer?
    func moduleManager() -> CPModuleManager
    
    func view() -> UXView
    func playerView() -> UXView
    
    func cpu() -> CPURL?
    func duration() -> TimeInterval
    func played() -> TimeInterval
    func state() -> CPState
    func presentationSize() -> CGSize
    
    func isPending() -> Bool
    func isSeeking() -> Bool
    
    /**
     Seeking URL.from
    */
    func isSeekHeading() -> Bool
    func isPlaying() -> Bool
    func isFinish() -> Bool
    
    /**
     User pause
    */
    func isDirectPause() -> Bool
    #if os(iOS)
    func isAirplaying() -> Bool
    #endif
    
    func play()
    func pause()
    
    /**
     User pause
    */
    func dpause()
    
    func beginSeek(_ time: TimeInterval)
    func seekTo(_ time: TimeInterval)
    func endSeek(_ time: TimeInterval)
    func seekToEnd()
}
