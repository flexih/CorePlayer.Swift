//
//  CorePlayerFeature.swift
//  CorePlayer
//
//  Created by flexih on 4/20/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation

@objc public enum CPState: Int {
    case None = 0,
         AssetReady,
         ItemReady,
         PlayReady,
         End,
         Failed,
         Error,
         Stop
}

public enum CPError: Int {
    case URLError = -1000,
         Error
}

@objc public protocol CorePlayerFeature: NSObjectProtocol {
    
    var scaleFill: Bool { get set}
    #if os(iOS)
    var allowAirPlay: Bool { get set }
    #endif
    
    func playURL(url: NSURL)
    func playURLs(cpus: Array<CPUrl>)
    func appendURLs(cpus: Array<CPUrl>)
    func appendURL(url: NSURL)
    
    func avplayer() -> AVPlayer?
    func moduleManager() -> CPModuleManager
    
    func view() -> UXView
    func playerView() -> UXView
    
    func cpu() -> CPUrl
    func duration() -> NSTimeInterval
    func played() -> NSTimeInterval
    func state() -> CPState
    func presentationSize() -> CGSize
    
    func isPending() -> Bool
    func isSeeking() -> Bool
    func isSeekHeading() -> Bool
    func isPlaying() -> Bool
    func isFinish() -> Bool
    func isDirectPause() -> Bool
    #if os(iOS)
    func isAirplaying() -> Bool
    #endif
    
    func play()
    func pause()
    func dpause()
    
    func beginSeek(time: NSTimeInterval)
    func seekTo(time: NSTimeInterval)
    func endSeek(time: NSTimeInterval)
    func seekToEnd()
}
