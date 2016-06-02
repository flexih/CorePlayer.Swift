//
//  ModuleView.swift
//  CorePlayer
//
//  Created by flexih on 4/28/15.
//  Copyright (c) 2015 flexih. All rights reserved.
//

import UIKit

class ModuleViewD: UIView, ModuleViewDelegate {
    
    weak var moduleManager: ModuleManager?
    weak var moduleDelegate: CorePlayerFeature?
    
    var moduelIndex: Int = 0
    var moduleShow: Bool = false
    
    let button = UIButton()
    
    func willPlay() {
        NSLog("willplay")
    }
    
    func layoutView() {
        self.frame = CGRectMake(0, 0, 100, 50)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = self.bounds
    }
    
    func initModule() {
        NSLog("initModule")
        button.backgroundColor = UIColor.blueColor()
        button.addTarget(self, action: #selector(buttonClicked), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func deinitModule() {
        NSLog("deinitModule")
    }

    func startPlay() {
        NSLog("startPlay")
    }
    
    func cancelPlay() {
        NSLog("cancelPlay")
    }
    
    func endPlayCode(state: CorePlayer.CPState) {
        NSLog("endPlayCode")
    }
    
    func willSection(cpu: CPURL) {
        NSLog("willSection")
    }
    
    func startSection(cpu: CPURL) {
        NSLog("startSection")
    }
    
    func endSection(cpu: CPURL) {
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
    
    func interrupt(reason: CorePlayer.InterruptionReason) {
        NSLog("interrupt")
    }
    
    func error(err: Int) {
        NSLog("error")
    }
}
