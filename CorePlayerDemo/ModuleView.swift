//
//  ModuleView.swift
//  CorePlayer
//
//  Created by flexih on 4/28/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import UIKit

class ModuleView: CPModuleView {
    
    let button = UIButton()
    
    func willPlay() {
        NSLog("willplay")
    }
    
    override func layoutView() {
        self.frame = CGRectMake(0, 0, 100, 50)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = self.bounds
    }
    
    override func initModule() {
        NSLog("initModule")
        button.backgroundColor = UIColor.blueColor()
        button.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("Pause", forState: UIControlState.Normal)
        button.setTitle("Play", forState: UIControlState.Selected)
        self.addSubview(button)
        self.moduleDelegate?.view().addSubview(self)
        
    }
    
    func buttonClicked() {
        button.selected = !button.selected
        if self.moduleDelegate!.isPlaying() {
            self.moduleDelegate?.pause()
        } else {
            self.moduleDelegate?.play()
        }
    }
    
    override func deinitModule() {
        NSLog("deinitModule")
    }

    func startPlay() {
        NSLog("startPlay")
    }
    
    func cancelPlay() {
        NSLog("cancelPlay")
    }
    
    func endPlayCode(errCode: Int) {
        NSLog("endPlayCode")
    }
    
    func willSection(cpu: CPUrl) {
        NSLog("willSection")
    }
    
    func startSection(cpu: CPUrl) {
        NSLog("startSection")
    }
    
    func endSection(cpu: CPUrl) {
        NSLog("endSection")
    }
    
    func willPend() {
        NSLog("willPend")
    }
    
    func endPend() {
        NSLog("endPend")
    }
    
    func willPause() {
        NSLog("willPause")
    }
    
    func endPause() {
        NSLog("endPause")
    }
    
    func startSeek(time: NSTimeInterval) {
        NSLog("startSeek")
    }
    
    func seekTo(time: NSTimeInterval) {
        NSLog("seekTo")
    }
    
    func endSeek(time: NSTimeInterval, isEnd: Bool) {
        NSLog("endSeek")
    }
    
    func durationAvailable(duration: NSTimeInterval) {
        NSLog("durationAvailable")
    }
    
    func played(duration: NSTimeInterval) {
        NSLog("played")
    }
    
    func playable(duration: NSTimeInterval) {
        NSLog("playable")
    }
    
    func appResign() {
        NSLog("appResign")
    }
    
    func appActive() {
        NSLog("appActive")
    }
    
    func presentationSize(size: CGSize) {
        NSLog("presentationSize")
    }
    
    func airplayShift(on: Bool) {
        NSLog("airplayShift")
    }
    
    func interrupt(reason: InterruptionReason) {
        NSLog("interrupt")
    }
    
    func error(err: Int) {
        NSLog("error")
    }
}
