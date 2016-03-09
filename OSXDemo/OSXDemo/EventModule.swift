//
//  EventModule.swift
//  OSXDemo
//
//  Created by flexih on 12/8/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import Cocoa
import AVFoundation

class EventModule: CPModule {
    
    var generator: AVAssetImageGenerator?

    func willPlay() {
        print("willPlay:\(moduleDelegate?.cpu()!.URL)")
    }

    func startPlay() {
        print("startPlay")
        
        func done0(time0: CMTime, image: CGImage?, time1: CMTime, result: AVAssetImageGeneratorResult, error: NSError?) {
            
        }
        
        generator = AVAssetImageGenerator(asset: AVURLAsset(URL: NSURL(string: "http://devimages.apple.com/samplecode/adDemo/ad.m3u8")!))
        generator?.generateCGImagesAsynchronouslyForTimes([NSValue(CMTime: CMTimeMakeWithSeconds(Float64(5), 10))]) {
            (time0: CMTime, image: CGImage?, time1: CMTime, result: AVAssetImageGeneratorResult, error: NSError?) in
            print(image)
            print(error)
        }
        
        do {
            try generator?.copyCGImageAtTime(CMTimeMakeWithSeconds(Float64(5), 10), actualTime: nil)
        } catch {
            
        }
    }

    func willPause() {
        print("willPause")
    }

    func endPause() {
        print("endPause")
    }

    func willPend() {
        print("willPend")
    }

    func endPend() {
        print("endPend")
    }

    func error(err: CPError) {
        print("error:\(err.rawValue)")
    }

    func endPlayCode(errCode: CPState) {
        print("endPlayCode:\(errCode.rawValue)")
    }

}
