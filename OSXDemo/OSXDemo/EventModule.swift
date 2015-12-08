//
//  EventModule.swift
//  OSXDemo
//
//  Created by flexih on 12/8/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import Cocoa

class EventModule: CPModule {
    
    func willPlay() {
        print("willPlay")
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
    
    func error(err: Int) {
        print("error:\(err)")
    }
    
    func endPlayCode(errCode: CPError) {
        print("endPlayCode:\(errCode)")
    }
    
}
