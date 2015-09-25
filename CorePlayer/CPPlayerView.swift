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
    case Aspect = 1,
         Fill
}

class CPPlayerView: UXView {
    var gravity: VideoGravity {
        
        get {
            let videoGravity = playerLayer().videoGravity
            if videoGravity == AVLayerVideoGravityResizeAspect {
                return .Aspect
            } else {
                return .Fill
            }
        }
        
        set(newGravity) {
            if newGravity == .Aspect {
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
    
    override class func layerClass() -> AnyClass {
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
            userInteractionEnabled = false
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
