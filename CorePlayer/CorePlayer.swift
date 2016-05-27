//
//  CorePlayer.swift
//  CorePlayer
//
//  Created by flexih on 4/21/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation
#if os(iOS)
    import UIKit
    public typealias UXView = UIView
#else
    import AppKit
    public typealias UXView = NSView
#endif

public class CorePlayer: NSObject {

    private struct Keys {
        static let TracksKey           = "tracks"
        static let StatusKey           = "status"
        static let PlaybackKeepUpKey   = "playbackLikelyToKeepUp"
        static let PresentationSizeKey = "presentationSize"
        static let RateKey             = "rate"
        static let DurationKey         = "duration"
        static let LoadedKey           = "loadedTimeRanges"
        static let PlayableKey         = "playable"
        static let CurrentItemKey      = "currentItem"
        static let TimedMetadataKey    = "currentItem.timedMetadata"
    }
    
    private struct KeyObserver {
        var keep = false
        var rate = false
        var duration = false
        var status = false
        var item = false
        var meta = false
        var loaded = false
        var airplay = false
        var presentation = false
    }
    
    private struct PlayerState {
        var state:CPState = .None
        var lastplay = false
        var seeking = false
        var play = false
        var pending = false
        var airplay = false
        var dpause = false
        var readyplay = false
        var seekhead = false
    }
    
    private var keyobserver = Keyobserver()
    private var playerstate = Playerstate()
    
    var moduleManager: ModuleManager
    private var contentView: ContentView
    private var playerView: PlayerView
    private var playerItem: AVPLayerItem?
    private var playerAsset: AVURLAsset?
    private var backPlayer: Player?
    private var backView: PlayerView?
    private var playedObserver: AnyObject?
    private var cpus: Array<CPURL> = []
    private var cpi: Int = 0
    private var player: Player? {
        willSet {
            if player != nil {
                deregisterPlayerEvent()
            }
        }
        
        didSet {
            playerView.playerLayer().player = player
        }
    }
    
    #if os(iOS)
    private var interruption: CPInterruption
    #endif
    
    public init(moduleManager: CPModuleManager) {
        contentView = ContentView()
        playerView = PlayerView()
        self.moduleManager = moduleManager
        
        #if os(iOS)
            interruption = CPInterruption()
            playerView.clipsToBounds = true
            playerView.backgroundColor = UIColor.blackColor()
        #else
            contentView.acceptsTouchEvents = true
        #endif
        
        super.init()
        
        moduleManager.moduleDelegate = self
        contentView.layoutManager = self
        contentView.addSubview(playerView)
        
        #if os(iOS)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        #endif
    }
    
    public override convenience init() {
        self.init(moduleManager: ModuleManager())
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        moduleManager.deinitModule()
        
        contentView.removeFromSuperview()
    }
    
    func observePlayed() {
        var span: NSTimeInterval = 1
        
        if durationSpan() > 0 {
            span = playerItem!.cduration() / NSTimeInterval(durationSpan())
        }
        
        if (span < 0.5) {
            span = 0.5
        } else if (span > 1) {
            span = 1
        }
        
        unobservePlayed()
        
        playedObserver = player!.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(Float64(span), Int32(NSEC_PER_SEC)), queue: dispatch_get_main_queue(), usingBlock: { [weak self] time in
            if let strongSelf = self {
                strongSelf.cpmoduleManager.played(strongSelf.played())
            }
        })
    }
    
    func unobservePlayed() {
        if playedObserver != nil {
            player!.removeTimeObserver(playedObserver!)
            playedObserver = nil
        }
    }
    
    func playable() -> NSTimeInterval {
        if let loadedRanges = playerItem?.loadedTimeRanges {
            if loadedRanges.count > 0 {
                let range: CMTimeRange = loadedRanges[0].CMTimeRangeValue
                let rangeTime = CMTimeAdd(range.start, range.duration)
                let playable = CMTimeGetSeconds(rangeTime)
                return playable
            }
        }
        return 0
    }
    
    public func durationSpan() -> Int {
        return 1
    }
    
    public func handlePlayEnd() {
        
    }
    
    public func handleError(error: CPError) {
        cpmoduleManager.error(error)
    }
    
    public func stop() {
        if playerstate.state == .PlayReady  ||
           playerstate.state == .ItemReady  ||
           playerstate.state == .AssetReady ||
           playerstate.state == .Error {
            
            if playerstate.state != .Error {
                playerstate.state = .Stop
            }
            
            stopPlaybackSession()
            
        } else if playerstate.state == .None {
            cpmoduleManager.cancelPlay()
        }
        
        if playerstate.state != .Stop {
            playerstate.state = .Stop
        }
    }
    
    func setdpause(dpause: Bool) {
        playerstate.dpause = dpause
    }
    
    func startPause() {
        cpmoduleManager.willPause()
    }
    
    func stopPause() {
        cpmoduleManager.endPause()
    }
    
    func startPending() {
        cpmoduleManager.willPend()
    }
    
    func stopPending() {
        cpmoduleManager.endPend()
    }
    
    func startLoading() {
        cpmoduleManager.willSection(cpu()!)
        cpmoduleManager.willPlay()
    }
    
    func stopLoading() {
        cpmoduleManager.startSection(cpu()!)
        
        if cpi == 0 {
            cpmoduleManager.startPlay()
            
            #if os(iOS)
            interruption.observeInterruption(self)
            #endif
        }
    }
    
    #if os(iOS)
        
    func appResignActive(notification: NSNotification) {
        if let player = player {
            playerstate.lastplay = player.isPlaying()
            
            if !isAirplaying() {
                player.pause()
            }
        }
        
        cpmoduleManager.appResign()
    }
    
    func appBecomeActive(notification: NSNotification) {
        if playerstate.readyplay {
            playerstate.lastplay = playerstate.readyplay
            playerstate.readyplay = false
        }
        
        if playerstate.dpause {
            playerstate.lastplay = false
        }
        
        if playerstate.lastplay {
            playerstate.lastplay = false
            player?.play()
        }
        
        cpmoduleManager.appActive()
    }
    
    #endif
    
    func stopPlaybackSession() {
        /*remove observe play event first*/
        deregisterRate()
        
        player?.pause()
        player?.cancelPendingPrerolls()
        playerItem?.cancelPendingSeeks()
        playerAsset?.cancelLoading()
        cpplayerView.playerLayer().player = nil
        
        backPlayer?.pause()
        backPlayer?.cancelPendingPrerolls()
        backPlayer?.currentItem?.asset.cancelLoading()
        backView?.playerLayer().player = nil
        
        unobservePlayed()
        
        deregisterPlayerEvent()
        deregisterPlayerItemEvent()
        
        if playerstate.state == .PlayReady ||
           playerstate.state == .End       ||
           playerstate.state == .Failed    ||
           playerstate.state == .Stop {
                cpmoduleManager.endSection(cpu()!)
                cpmoduleManager.endPlayCode(playerstate.state)
                #if os(iOS)
                interruption.unobserver()
                #endif
        }
    
        playerstate.play = false
        playerstate.dpause = false
        playerstate.seeking = false
        playerstate.seekhead = false
        playerstate.pending = false
        playerstate.readyplay = false
    
        cpi = 0
        cpus.removeAll(keepCapacity: true)
        playerAsset = nil
        playerItem = nil
        player = nil
        backPlayer = nil
        backView = nil
    }
    
    func playEnded(end: Bool) {
        playerstate.state = !end ? .Failed : .End
        
        if cpi + 1 >= cpus.count || playerstate.state == .Failed {
            stopPlaybackSession()
            
            if playerstate.state == .Failed {
                handleError(.Error)
            } else {
                handlePlayEnd()
            }
            
        } else {
            deregisterRate()
            player?.pause()
            playerItem?.cancelPendingSeeks()
            playerAsset?.cancelLoading()
            unobservePlayed()
            deregisterPlayerEvent()
            deregisterPlayerItemEvent()
            
            playerstate.play = false
            playerstate.dpause = false
            playerstate.seeking = false
            playerstate.seekhead = false
            playerstate.pending = false
            playerstate.readyplay = false
            
            playerstate.state = .End
            cpmoduleManager.endSection(cpu()!)
            
            cpi += 1
            playerstate.state = .ItemReady
            
            cpmoduleManager.willSection(cpu()!)
            
            playerItem = backPlayer?.currentItem as? CPPlayerItem
            playerAsset = playerItem?.asset as? AVURLAsset
            
            registerPlayerItemEvent()
            
            let superview: UXView! = cpplayerView.superview
            
            cpplayerView.removeFromSuperview()
            
            if superview == cpview {
                #if os(iOS)
                    cpview.insertSubview(backView!, atIndex:0)
                #else
                    cpview.addSubview(backView!, positioned:.Below, relativeTo:nil)
                #endif
            } else {
                superview.addSubview(backView!)
            }
            
            backView!.frame = cpplayerView.frame
            cpplayerView = backView!
            cpplayerView.gravity = scaleFill ? .Fill : .Aspect
            player = backPlayer
            #if os(iOS)
                player!.allowsExternalPlayback = allowAirPlay
            #endif
            backPlayer = nil
            backView = nil
            
            registerPlayerEvent()
            
            if playerItem?.status == .ReadyToPlay {
                readyToPlay()
            } else {
                startPending()
            }
            
            loadNext()
        }
    }
    
    func playerItemDidFailed(notification: NSNotification) {
        playEnded(false)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        playEnded(player!.isPlayToEnd())
    }
    
    func readyToPlay() {
        playerstate.state = .PlayReady
        stopLoading()
        
        if cpu()!.from > 0.0 {
            playerstate.seekhead = true
            
            player?.seekToTime(CMTimeMakeWithSeconds(Float64(cpu()!.from), Int32(NSEC_PER_SEC)), accurate: true, completion: { [weak self] finished in
                if let strongSelf = self {
                    strongSelf.playerstate.seekhead = false
                    
                    if finished {
                        strongSelf.player?.play()
                    }
                }
            })
            
            cpu()!.from = 0.0
        }
        
        var active = true
        #if os(iOS)
            active = UIApplication.sharedApplication().applicationState == .Active || playerstate.airplay
        #endif
            
        if playerstate.seekhead || playerstate.dpause || !active {
            playerstate.readyplay = !playerstate.dpause
        } else if !playerstate.seekhead {
            player?.play()
        }
            
        if playerItem!.cduration() > 0 {
            cpmoduleManager.durationAvailable(duration())
        }
    }
    
    func registerPlayerItemEvent() {
        let options = NSKeyValueObservingOptions([.Old, .New])
        
        playerItem?.addObserver(self, forKeyPath:kStatusKey, options:options, context: UnsafeMutablePointer<Void>(unsafeAddressOf(kStatusKey)))
        keyobserver.status = true
        
        playerItem?.addObserver(self, forKeyPath:kPlaybackKeepUpKey, options:options, context:nil)
        keyobserver.keep = true
        
        playerItem?.addObserver(self, forKeyPath:kPresentationSizeKey, options:options, context:nil)
        keyobserver.presentation = true
        
        playerItem?.addObserver(self, forKeyPath:kDurationKey, options:options, context:nil)
        keyobserver.duration = true
        
        playerItem?.addObserver(self, forKeyPath:kLoadedKey, options:options, context:nil)
        keyobserver.loaded = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CorePlayer.playerItemDidReachEnd(_:)), name:AVPlayerItemDidPlayToEndTimeNotification, object:playerItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CorePlayer.playerItemDidFailed(_:)), name:AVPlayerItemFailedToPlayToEndTimeNotification, object:playerItem)
    }
    
    func deregisterPlayerItemEvent() {
        if keyobserver.status {
            playerItem?.removeObserver(self, forKeyPath:kStatusKey)
            keyobserver.status = false
        }
        
        if keyobserver.keep {
            playerItem?.removeObserver(self, forKeyPath:kPlaybackKeepUpKey)
            keyobserver.keep = false
        }
        
        if keyobserver.presentation {
            playerItem?.removeObserver(self, forKeyPath:kPresentationSizeKey)
            keyobserver.presentation = false
        }
        
        if keyobserver.duration {
            playerItem?.removeObserver(self, forKeyPath:kDurationKey)
            keyobserver.duration = false
        }
        
        if keyobserver.loaded {
            playerItem?.removeObserver(self, forKeyPath:kLoadedKey)
            keyobserver.loaded = false
        }
        
        #if os(iOS)
            if keyobserver.airplay {
                player?.unlistenAirPlayState(self)
                keyobserver.airplay = false
            }
        #endif
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:AVPlayerItemDidPlayToEndTimeNotification, object:playerItem)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:AVPlayerItemFailedToPlayToEndTimeNotification, object:playerItem)
    }
    
    func registerPlayerEvent() {
        let options = NSKeyValueObservingOptions([.Old, .New])
        
        player?.addObserver(self, forKeyPath:kRateKey, options:options, context:nil)
        keyobserver.rate = true
        
        player?.addObserver(self, forKeyPath:kCurrentItemKey, options:options, context:nil)
        keyobserver.item = true
        
        player?.addObserver(self, forKeyPath:kTimedMetadataKey, options:options, context:nil)
        keyobserver.meta = true
        
        #if os(iOS)
            keyobserver.airplay = player?.listenAirPlayState(self) ?? false
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CorePlayer.audioSessionRouteChange(_:)), name: AVAudioSessionRouteChangeNotification, object: nil)
        #endif
    }
    
    func audioSessionRouteChange(notification: NSNotification) {
        
    }
    
    func deregisterPlayerEvent() {
        if keyobserver.rate {
            player?.removeObserver(self, forKeyPath:kRateKey)
            keyobserver.rate = false
        }
        
        if keyobserver.item {
            player?.removeObserver(self, forKeyPath:kCurrentItemKey)
            keyobserver.item = false
        }
        
        if keyobserver.meta {
            player?.removeObserver(self, forKeyPath:kTimedMetadataKey)
            keyobserver.meta = false
        }
        
        #if os(iOS)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVAudioSessionRouteChangeNotification, object: nil)
        #endif
    }
    
    func deregisterRate() {
        if keyobserver.rate {
            player?.removeObserver(self, forKeyPath:kRateKey)
            keyobserver.rate = false
        }
    }
    
    func loadNext() {
        if backPlayer != nil {
            return
        }
        
        if cpi + 1 < cpus.count {
            let cpu = cpus[cpi + 1]
            let asset = AVURLAsset(CPU: cpu)
            let playerItem = CPPlayerItem(asset: asset)
            
            backPlayer = CPPlayer(playerItem: playerItem)
            backPlayer!.actionAtItemEnd = .Pause
            #if os(iOS)
                backPlayer!.allowsExternalPlayback = false
            #endif
            backView = CPPlayerView()
            backView!.playerLayer().player = backPlayer
        }
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == kPlaybackKeepUpKey {
            if playerstate.state == .AssetReady ||
               playerstate.state == .ItemReady {
                return
            }

            let keep = (change?[NSKeyValueChangeNewKey] as! NSNumber).boolValue
            
            if keep {
                stopPending()
            } else {
                startPending()
            }
            
            playerstate.pending = !keep
            
        } else if keyPath == kRateKey {
            let rate = (change?[NSKeyValueChangeNewKey] as! NSNumber).floatValue
            let isPlay = CPPlayer.isRatePlaying(rate)
            
            if isPlay {
                if playedObserver == nil {
                    observePlayed()
                }
                
                if !playerstate.play {
                    stopPause()
                }
                
                if playerstate.readyplay {
                    playerstate.readyplay = false
                }
                
            } else {
                if playedObserver != nil {
                    unobservePlayed()
                }
                
                if playerstate.play {
                    startPause()
                }
            }
            
            playerstate.play = isPlay
            
        } else if keyPath == kLoadedKey {
            let loadedRanges = playerItem!.loadedTimeRanges
            if loadedRanges.count > 0 {
                cpmoduleManager.playable(playable())
            }
            
        } else if keyPath == kStatusKey {
            let status = AVPlayerStatus(rawValue: (change?[NSKeyValueChangeNewKey] as! NSNumber).integerValue)!
            switch (status) {
            case .ReadyToPlay:
                if playerstate.state.rawValue >= CPState.PlayReady.rawValue {
                    #if os(iOS)
                        let applicationState = UIApplication.sharedApplication().applicationState
                        if ((applicationState == .Active || playerstate.airplay) && !playerstate.dpause) {
                            player!.play()
                        }
                    #else
                        player!.play()
                    #endif
                    return
                }
                
                readyToPlay()
                
            case .Failed, .Unknown:
                if playerstate.state == .PlayReady {
                    playerstate.state = .Failed
                } else {
                    playerstate.state = .Error
                }
                
                stopPlaybackSession()
                handleError(.Error)
            }
            
        } else if keyPath == kDurationKey {
            cpmoduleManager.durationAvailable(duration())
            
        } else if keyPath == kCurrentItemKey {
            
        } else if keyPath == kTimedMetadataKey {
            
        } else if keyPath == kPresentationSizeKey {
            #if os(iOS)
                cpmoduleManager.presentationSize((change?[NSKeyValueChangeNewKey] as! NSValue).CGSizeValue())
            #else
                cpmoduleManager.presentationSize((change?[NSKeyValueChangeNewKey] as! NSValue).sizeValue)
            #endif
        } else {
            #if os(iOS)
            if keyPath == player!.airPlayObserverKey() {
                playerstate.airplay = (change?[NSKeyValueChangeNewKey] as! NSNumber).boolValue
                cpmoduleManager.airplayShift(playerstate.airplay)
                return
            }
            #endif
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

extension CorePlayer: CPContentLayoutManager {

    func contentsLayout(view: UXView) {
        let v: UXView = view.subviews[0]

        if v.isMemberOfClass(CPPlayerView) {
            v.frame = view.bounds
        }
        
        cpmoduleManager.layoutView()
    }
    
    #if os(iOS)
    
    func contentsTouchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        cpmoduleManager.touchesBegan(touches, withEvent: event)
    }
    
    func contentsTouchesMoved(touches: Set<NSObject>, withEvent event: UIEvent?) {
        cpmoduleManager.touchesMoved(touches, withEvent: event)
    }
    
    func contentsTouchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?) {
        cpmoduleManager.touchesEnded(touches, withEvent: event)
    }
    
    func contentsTouchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent?) {
        cpmoduleManager.touchesCancelled(touches, withEvent: event)
    }
    
    #else
    
    func contentsMouseDown(theEvent: NSEvent) {
        cpmoduleManager.mouseDown(theEvent)
    }
    
    func contentsRightMouseDown(theEvent: NSEvent) {
        cpmoduleManager.rightMouseDown(theEvent)
    }
    
    func contentsOtherMouseDown(theEvent: NSEvent) {
        cpmoduleManager.otherMouseDown(theEvent)
    }
    
    func contentsMouseUp(theEvent: NSEvent) {
        cpmoduleManager.mouseUp(theEvent)
    }
    
    func contentsRightMouseUp(theEvent: NSEvent) {
        cpmoduleManager.rightMouseUp(theEvent)
    }
    
    func contentsOtherMouseUp(theEvent: NSEvent) {
        cpmoduleManager.otherMouseUp(theEvent)
    }
    
    func contentsMouseMoved(theEvent: NSEvent) {
        cpmoduleManager.mouseMoved(theEvent)
    }
    
    func contentsMouseDragged(theEvent: NSEvent) {
        cpmoduleManager.mouseDragged(theEvent)
    }
    
    func contentsScrollWheel(theEvent: NSEvent) {
        cpmoduleManager.scrollWheel(theEvent)
    }
    
    func contentsRightMouseDragged(theEvent: NSEvent) {
        cpmoduleManager.rightMouseDragged(theEvent)
    }
    
    func contentsOtherMouseDragged(theEvent: NSEvent) {
        cpmoduleManager.otherMouseDragged(theEvent)
    }
    
    func contentsMouseEntered(theEvent: NSEvent) {
        cpmoduleManager.mouseEntered(theEvent)
    }
    
    func contentsMouseExited(theEvent: NSEvent) {
        cpmoduleManager.mouseExited(theEvent)
    }
    
    func contentsKeyDown(theEvent: NSEvent) {
        cpmoduleManager.keyDown(theEvent)
    }
    
    func contentsKeyUp(theEvent: NSEvent) {
        cpmoduleManager.keyUp(theEvent)
    }
    
    #endif
}

#if os(iOS)

extension CorePlayer: CPInterruptionDelegate {
    
    func interrupt(reason: InterruptionReason) {
        cpmoduleManager.interrupt(reason)
    }
}
    
#endif

extension CorePlayer: CorePlayerFeature {
    
    public var scaleFill: Bool {
        
        get {
            return cpplayerView.gravity == .Fill
        }
        
        set {
            cpplayerView.gravity = scaleFill ? .Fill : .Aspect
        }
    }
    
    #if os(iOS)
    public var allowAirPlay: Bool {
        
        get {
            if player != nil {
                return player!.allowsExternalPlayback
            } else {
                return false
            }
        }
        
        set {
            player?.allowsExternalPlayback = newValue
        }
    }
    #endif

    public func playURL(URL: NSURL) {
        playURLs([CPURL(URL: URL)])
    }
    
    public func playURLs(cpus: Array<CPURL>) {
        if playerstate.state == .PlayReady ||
           playerstate.state == .ItemReady ||
           playerstate.state == .AssetReady {
            stopPlaybackSession()
        }
        
        if cpus.count == 0 {
            handleError(.URLError)
            return
        }
        
        cpi = 0
        self.cpus = cpus
        playerstate.state = .ItemReady
        playerAsset = AVURLAsset(CPU: cpu()!)
        playerItem = CPPlayerItem(asset: playerAsset!)
        
        registerPlayerItemEvent()
        
        player = CPPlayer(playerItem: playerItem! as AVPlayerItem)
        player!.actionAtItemEnd = .Pause
        #if os(iOS)
        player!.allowsExternalPlayback = allowAirPlay
        #endif
        
        registerPlayerEvent()
        
        startLoading()
        
        loadNext()
    }

    public func appendURL(URL: NSURL) {
        appendURLs([CPURL(URL: URL)])
    }
    
    public func appendURLs(cpus: Array<CPURL>) {
        
        self.cpus.appendContentsOf(cpus)
        
        loadNext()
    }

    public func avplayer() -> AVPlayer? {
        return player
    }

    public func moduleManager() -> CPModuleManager {
        return cpmoduleManager
    }

    public func view() -> UXView {
        return cpview
    }
    
    public func playerView() -> UXView {
        return cpplayerView
    }

    public func cpu() -> CPURL? {
        if cpus.isEmpty {
            return nil
        }
        
        return cpus[cpi]
    }

    public func duration() -> NSTimeInterval {
        if let playerItem = playerItem {
            return playerItem.cduration()
        }
        
        return 0
    }
    
    public func played() -> NSTimeInterval {
        if playerstate.state == .End {
            return duration()
        }
        
        if let player = player {
            var rlt = player.ccurrentTime()
            let d = playerItem?.cduration() ?? 0
            
            if rlt > d {
                rlt = d
            }
            
            return rlt
        }
        
        return 0
    }

    public func state() -> CPState {
        return playerstate.state
    }

    public func presentationSize() -> CGSize {
        return player?.currentItem?.presentationSize ?? CGSizeZero
    }

    public func isPending() -> Bool {
        return playerstate.pending
    }
    
    public func isSeekHeading() -> Bool {
        return playerstate.seekhead
    }
    
    public func isSeeking() -> Bool {
        return playerstate.seeking
    }
    
    public func isPlaying() -> Bool {
        return player?.isPlaying() ?? false
    }

    public func isDirectPause() -> Bool {
        return playerstate.dpause
    }
    
    #if os(iOS)
    public func isAirplaying() -> Bool {
        return player?.externalPlaybackActive ?? false
    }
    #endif
    
    public func isFinish() -> Bool {
        return playerstate.state == .End
    }

    public func play() {
        playerstate.dpause = false
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func dpause() {
        playerstate.dpause = true
        pause()
    }

    public func beginSeek(time: NSTimeInterval) {
        if playerstate.state != .PlayReady {
            return
        }
        
        unobservePlayed()
        cpmoduleManager.startSeek(time)
    }
    
    public func seekTo(time: NSTimeInterval) {
        if playerstate.state != .PlayReady {
            return
        }
        
        playerItem?.cancelPendingSeeks()
        
        playerstate.seeking = true
        
        player?.seekToTime(CMTimeMakeWithSeconds(Float64(time), Int32(NSEC_PER_SEC)), accurate: true, completion: { [weak self] finished in
            if let strongSelf = self {
                strongSelf.playerstate.seeking = false
                
                if finished {
                    strongSelf.observePlayed()
                }
            }
        })
        
        cpmoduleManager.seekTo(time)
    }
    
    public func endSeek(time: NSTimeInterval) {
        if playerstate.state != .PlayReady {
            return
        }
        
        if !playerstate.seeking && playedObserver == nil {
            observePlayed()
        }
        
        var isend = false
        let end = playerItem!.cduration()
        
        if (isfinite(end) && fabs(time - end) < 0.5) {
            if (playerstate.seeking) {
                playerItem!.cancelPendingSeeks()
            }
            
            isend = true
            cpmoduleManager.endSeek(time, isEnd:isend)
            seekToEnd()
        } else {
            cpmoduleManager.endSeek(time, isEnd:isend)
        }
    }
    
    public func seekToEnd() {
        playEnded(true)
    }
}
