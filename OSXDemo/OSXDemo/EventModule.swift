//
//  EventModule.swift
//  OSXDemo
//
//  Created by flexih on 12/8/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import Cocoa
import AVFoundation

class EventModule: Module {

    func willPlay() {
        print("willPlay:\(moduleDelegate?.cpu()!.URL)")
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

    func error(err: CorePlayer.CPError) {
        print("error:\(err.rawValue)")
    }

    func endPlayCode(errCode: CorePlayer.CPState) {
        print("endPlayCode:\(errCode.rawValue)")
    }

}
