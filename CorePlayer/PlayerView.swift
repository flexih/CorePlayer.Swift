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
    case Aspect = 1
    case Fill
}

class PlayerView: UXView {
    var gravity: VideoGravity {
        
        get {
            let videoGravity = playerLayer().videoGravity
            if videoGravity == AVLayerVideoGravityResizeAspect {
                return .Aspect
            } else {
                return .Fill
            }
        }
        
        set {
            if newValue == .Aspect {
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

    override var frame: CGRect {
        get {
            return super.frame
        }

        set {
            var newFrame = newValue
            #if __USE_SCALE__
                newFrame.size.width *= scale
                newFrame.size.height *= scale
                newFrame.origin.x = floor((newValue.size.width - newFrame.size.width) * 0.5)
                newFrame.origin.y = floor((newValue.size.height - newFrame.size.height) * 0.5)
            #endif
            super.frame = newFrame
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        #if os(iOS)
            userInteractionEnabled = false
        #else
            wantsLayer = true
            layer = AVPlayerLayer()
        #endif
    }
    
    #if os(iOS)
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    #else
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    #endif
    
    func playerLayer() -> AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
}

#if os(iOS)
extension PlayerView {
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
}
#endif
