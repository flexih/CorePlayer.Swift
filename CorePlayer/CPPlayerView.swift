//
//  CPPlayerView.swift
//  CorePlayer
//
//  Created by flexih on 4/14/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import AVFoundation
#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

enum VideoGravity: Int {
    case aspect = 1
    case fill
}

class CPPlayerView: UXView {
    var gravity: VideoGravity {
        
        get {
            let videoGravity = playerLayer().videoGravity
            if videoGravity == AVLayerVideoGravityResizeAspect {
                return .aspect
            } else {
                return .fill
            }
        }
        
        set(newGravity) {
            if newGravity == .aspect {
                playerLayer().videoGravity = AVLayerVideoGravityResizeAspect
            } else {
                playerLayer().videoGravity = AVLayerVideoGravityResizeAspectFill
            }
        }
    }
    
    var scale: CGFloat = 1 {
        didSet {
            let frame = self.frame
            self.frame = frame
        }
    }
    
    #if os(iOS)
    
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    #else
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    #endif
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if os(iOS)
            isUserInteractionEnabled = false
        #else
            wantsLayer = true
            layer = AVPlayerLayer()
        #endif
    }
    
    override var frame: CGRect {
        
        get {
            return super.frame
        }
        
        set(newFrame) {
            var frame = newFrame
            #if __USE_SCALE__
                frame.size.width *= scale
                frame.size.height *= scale
                frame.origin.x = floor((newFrame.size.width - frame.size.width) * 0.5)
                frame.origin.y = floor((newFrame.size.height - frame.size.height) * 0.5)
            #endif
            super.frame = frame
        }
    }
    
    func playerLayer() -> AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
}
