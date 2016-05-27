//
//  CorePlayerFeature.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation

@objc public protocol CorePlayerFeature: NSObjectProtocol {
    
    var scaleFill: Bool { get set }
    #if os(iOS)
    var allowAirPlay: Bool { get set }
    #endif
    
    func playURL(URL: NSURL)
    func playURLs(cpus: Array<CPURL>)
    func appendURLs(cpus: Array<CPURL>)
    func appendURL(URL: NSURL)
    
    func avplayer() -> AVPlayer?
    func moduleManager() -> CPModuleManager
    
    func view() -> UXView
    func playerView() -> UXView
    
    func cpu() -> CPURL?
    func duration() -> NSTimeInterval
    func played() -> NSTimeInterval
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
    
    func beginSeek(time: NSTimeInterval)
    func seekTo(time: NSTimeInterval)
    func endSeek(time: NSTimeInterval)
    func seekToEnd()
}
