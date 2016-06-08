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
#else
    import AppKit
#endif

public class CorePlayer: NSObject {

    public enum State: Int {
        case None       = 0
        case AssetReady = 1
        case ItemReady  = 2
        case PlayReady  = 3
        case End        = 4
        case Failed     = 5
        case Error      = 6
        case Stop       = 7
    }

    public enum Error: Int {
        case URLError = -1000
        case Error    = -1001
    }

    public enum ModuleType: Int {
        case Feature = 1
        case View    = 2
    }

    public enum InterruptionReason: Int {
        case NewDeviceAvailable   = 1 /// earphone pulgged in
        case OldDeviceUnavailable = 2 /// earphone pulgged out
        case AudioSessionBegan    = 3 /// message alert, calendar alert, etc.
        case AudioSessionEnd      = 4
    }

    private struct Keys {
        static let Tracks           = "tracks"
        static let Status           = "status"
        static let PlaybackKeepUp   = "playbackLikelyToKeepUp"
        static let PresentationSize = "presentationSize"
        static let Rate             = "rate"
        static let Duration         = "duration"
        static let Loaded           = "loadedTimeRanges"
        static let Playable         = "playable"
        static let CurrentItem      = "currentItem"
        static let TimedMetadata    = "currentItem.timedMetadata"
    }

    private struct KeyObserver {
        var keep         = false
        var rate         = false
        var duration     = false
        var status       = false
        var item         = false
        var meta         = false
        var loaded       = false
        var airplay      = false
        var presentation = false
    }

    private struct PlayerState {
        var state     = State.None
        var lastplay  = false
        var seeking   = false
        var play      = false
        var pending   = false
        var airplay   = false
        var dpause    = false
        var readyplay = false
        var seekhead  = false
    }

    private struct URL {
      let URL: CPURL
      let asset: AVURLAsset
      var didSeekHead = false

      func preload() {
        asset.loadValuesAsynchronouslyForKeys(["status"], completionHandler: nil)
      }

      func cancelLoading() {

      }

      func deinit() {
        cancelLoading()
      }
    }

    private var keyobserver = KeyObserver()
    private var playerstate = PlayerState()

    public private(set) var moduleManager: ModuleManager
    private var contentView: ContentView
    private var playerView: PlayerView
    private var playerItem: AVPlayerItem?
    private var playerAsset: AVURLAsset?
    private var playedObserver: AnyObject?
    private var cpus: Array<CPURL> = []
    private var cpi: Int = 0
    private var player: AVPlayer? {
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
    private var interruption: Interruption
    #endif

    public init(moduleManager: ModuleManager) {
        contentView = ContentView()
        playerView = PlayerView()
        self.moduleManager = moduleManager

        #if os(iOS)
            interruption = Interruption()
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

    private func observePlayed() {
        var span: NSTimeInterval = 1

        if durationSpan() > 0 {
            span = playerItem!.Duration / durationSpan()
        }

        if (span < 0.5) {
            span = 0.5
        } else if (span > 1) {
            span = 1
        }

        unobservePlayed()

        playedObserver = player!.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(Float64(span), Int32(NSEC_PER_SEC)), queue: dispatch_get_main_queue(), usingBlock: { [weak self] time in
            self?.moduleManager.played(self?.played() ?? 0)
        })
    }

    private func unobservePlayed() {
        if playedObserver != nil {
            player!.removeTimeObserver(playedObserver!)
            playedObserver = nil
        }
    }

    private func playable() -> NSTimeInterval {
        return playerItem?.Playable ?? 0
    }

    public func durationSpan() -> NSTimeInterval {
        return 1
    }

    public func handlePlayEnd() {

    }

    public func handleError(error: Error) {
        moduleManager.error(error)
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
            moduleManager.cancelPlay()
        }

        if playerstate.state != .Stop {
            playerstate.state = .Stop
        }
    }

    func setdpause(dpause: Bool) {
        playerstate.dpause = dpause
    }

    func startPause() {
        moduleManager.willPause()
    }

    func stopPause() {
        moduleManager.endPause()
    }

    func startPending() {
        moduleManager.willPend()
    }

    func stopPending() {
        moduleManager.endPend()
    }

    func startLoading() {
        moduleManager.willSection(cpu()!)
        moduleManager.willPlay()
    }

    func stopLoading() {
        moduleManager.startSection(cpu()!)

        if cpi == 0 {
            moduleManager.startPlay()

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

        moduleManager.appResign()
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

        moduleManager.appActive()
    }

    #endif

    func stopPlaybackSession() {
        /*remove observe play event first*/
        deregisterRate()

        player?.pause()
        player?.cancelPendingPrerolls()
        playerItem?.cancelPendingSeeks()
        playerAsset?.cancelLoading()
        playerView.playerLayer().player = nil

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
                moduleManager.endSection(cpu()!)
                moduleManager.endPlayCode(playerstate.state)
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
            moduleManager.endSection(cpu()!)

            cpi += 1
            playerstate.state = .ItemReady

            moduleManager.willSection(cpu()!)

            playerItem = backPlayer?.currentItem
            playerAsset = playerItem?.asset as? AVURLAsset

            registerPlayerItemEvent()

            let superview: UXView! = playerView.superview

            playerView.removeFromSuperview()

            if superview == contentView {
                #if os(iOS)
                    contentView.insertSubview(backView!, atIndex:0)
                #else
                    contentView.addSubview(backView!, positioned:.Below, relativeTo:nil)
                #endif
            } else {
                superview.addSubview(backView!)
            }

            backView!.frame = playerView.frame
            playerView = backView!
            playerView.gravity = scaleFill ? .Fill : .Aspect
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

//            cpu()!.from = 0.0
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

        if playerItem!.Duration > 0 {
            moduleManager.durationAvailable(duration())
        }
    }

    func registerPlayerItemEvent() {
        let options = NSKeyValueObservingOptions([.Old, .New])

        playerItem?.addObserver(self, forKeyPath: Keys.Status, options: options, context: UnsafeMutablePointer<Void>(unsafeAddressOf(Keys.Status)))
        keyobserver.status = true

        playerItem?.addObserver(self, forKeyPath: Keys.PlaybackKeepUp, options: options, context: nil)
        keyobserver.keep = true

        playerItem?.addObserver(self, forKeyPath: Keys.PresentationSize, options: options, context: nil)
        keyobserver.presentation = true

        playerItem?.addObserver(self, forKeyPath: Keys.Duration, options: options, context: nil)
        keyobserver.duration = true

        playerItem?.addObserver(self, forKeyPath: Keys.Loaded, options: options, context: nil)
        keyobserver.loaded = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(playerItemDidReachEnd(_:)), name:AVPlayerItemDidPlayToEndTimeNotification, object:playerItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(playerItemDidFailed(_:)), name:AVPlayerItemFailedToPlayToEndTimeNotification, object:playerItem)
    }

    func deregisterPlayerItemEvent() {
        if keyobserver.status {
            playerItem?.removeObserver(self, forKeyPath: Keys.Status)
            keyobserver.status = false
        }

        if keyobserver.keep {
            playerItem?.removeObserver(self, forKeyPath: Keys.PlaybackKeepUp)
            keyobserver.keep = false
        }

        if keyobserver.presentation {
            playerItem?.removeObserver(self, forKeyPath: Keys.PresentationSize)
            keyobserver.presentation = false
        }

        if keyobserver.duration {
            playerItem?.removeObserver(self, forKeyPath: Keys.Duration)
            keyobserver.duration = false
        }

        if keyobserver.loaded {
            playerItem?.removeObserver(self, forKeyPath: Keys.Loaded)
            keyobserver.loaded = false
        }

        #if os(iOS)
            if keyobserver.airplay {
//                player?.unlistenAirPlayState(self)
                keyobserver.airplay = false
            }
        #endif

        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemFailedToPlayToEndTimeNotification, object: playerItem)
    }

    func registerPlayerEvent() {
        let options = NSKeyValueObservingOptions([.Old, .New])

        player?.addObserver(self, forKeyPath: Keys.Rate, options: options, context: nil)
        keyobserver.rate = true

        player?.addObserver(self, forKeyPath: Keys.CurrentItem, options:options, context:nil)
        keyobserver.item = true

        player?.addObserver(self, forKeyPath: Keys.TimedMetadata, options:options, context:nil)
        keyobserver.meta = true

        #if os(iOS)
//            keyobserver.airplay = player?.listenAirPlayState(self) ?? false
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(audioSessionRouteChange(_:)), name: AVAudioSessionRouteChangeNotification, object: nil)
        #endif
    }

    func audioSessionRouteChange(notification: NSNotification) {

    }

    func deregisterPlayerEvent() {
        if keyobserver.rate {
            player?.removeObserver(self, forKeyPath: Keys.Rate)
            keyobserver.rate = false
        }

        if keyobserver.item {
            player?.removeObserver(self, forKeyPath: Keys.CurrentItem)
            keyobserver.item = false
        }

        if keyobserver.meta {
            player?.removeObserver(self, forKeyPath: Keys.TimedMetadata)
            keyobserver.meta = false
        }

        #if os(iOS)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVAudioSessionRouteChangeNotification, object: nil)
        #endif
    }

    func deregisterRate() {
        if keyobserver.rate {
            player?.removeObserver(self, forKeyPath: Keys.Rate)
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
            let playerItem = AVPlayerItem(asset: asset)

            backPlayer = AVPlayer(playerItem: playerItem)
            backPlayer!.actionAtItemEnd = .Pause
            #if os(iOS)
                backPlayer!.allowsExternalPlayback = false
            #endif
            backView = PlayerView()
            backView!.playerLayer().player = backPlayer
        }
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == Keys.PlaybackKeepUp {
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

        } else if keyPath == Keys.Rate {
            let rate = (change?[NSKeyValueChangeNewKey] as! NSNumber).floatValue
            let isPlay = AVPlayer.isRatePlaying(rate)

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

        } else if keyPath == Keys.Loaded {
            let loadedRanges = playerItem!.loadedTimeRanges
            if loadedRanges.count > 0 {
                moduleManager.playable(playable())
            }

        } else if keyPath == Keys.Status {
            let status = AVPlayerStatus(rawValue: (change?[NSKeyValueChangeNewKey] as! NSNumber).integerValue)!
            switch (status) {
            case .ReadyToPlay:
                if playerstate.state.rawValue >= State.PlayReady.rawValue {
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

        } else if keyPath == Keys.Duration {
            moduleManager.durationAvailable(duration())

        } else if keyPath == Keys.CurrentItem {

        } else if keyPath == Keys.TimedMetadata {

        } else if keyPath == Keys.PresentationSize {
            #if os(iOS)
                moduleManager.presentationSize((change?[NSKeyValueChangeNewKey] as! NSValue).CGSizeValue())
            #else
                moduleManager.presentationSize((change?[NSKeyValueChangeNewKey] as! NSValue).sizeValue)
            #endif
        } else {
            #if os(iOS)
//            if keyPath == player!.airPlayObserverKey() {
//                playerstate.airplay = (change?[NSKeyValueChangeNewKey] as! NSNumber).boolValue
//                moduleManager.airplayShift(playerstate.airplay)
//                return
//            }
            #endif
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

extension CorePlayer: CorePlayerFeature {

    public var scaleFill: Bool {

        get {
            return playerView.gravity == .Fill
        }

        set {
            playerView.gravity = scaleFill ? .Fill : .Aspect
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
        playerItem = AVPlayerItem(asset: playerAsset!)

        registerPlayerItemEvent()

        player = AVPlayer(playerItem: playerItem! as AVPlayerItem)
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

    public func playerview() -> UXView {
        return playerView
    }

    public func view() -> UXView {
        return contentView
    }

    public func cpu() -> CPURL? {
        if cpus.isEmpty {
            return nil
        }

        return cpus[cpi]
    }

    public func duration() -> NSTimeInterval {
        return playerItem?.Duration ?? 0
    }

    public func played() -> NSTimeInterval {
        if playerstate.state == .End {
            return duration()
        }

        if let player = player {
            var rlt = player.CurrentTime()
            let d = playerItem?.Duration ?? 0

            if rlt > d {
                rlt = d
            }

            return rlt
        }

        return 0
    }

    public func state() -> State {
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
        moduleManager.startSeek(time)
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

        moduleManager.seekTo(time)
    }

    public func endSeek(time: NSTimeInterval) {
        if playerstate.state != .PlayReady {
            return
        }

        if !playerstate.seeking && playedObserver == nil {
            observePlayed()
        }

        var isend = false
        let end = playerItem!.Duration

        if (isfinite(end) && fabs(time - end) < 0.5) {
            if (playerstate.seeking) {
                playerItem!.cancelPendingSeeks()
            }

            isend = true
            moduleManager.endSeek(time, isEnd:isend)
            seekToEnd()
        } else {
            moduleManager.endSeek(time, isEnd:isend)
        }
    }

    public func seekToEnd() {
        playEnded(true)
    }
}
