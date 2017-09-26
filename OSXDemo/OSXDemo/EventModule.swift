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
        print("willPlay:\(moduleDelegate!.cpu()!.URL.absoluteString)")
    }

    func startPlay() {
        print("startPlay")
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
