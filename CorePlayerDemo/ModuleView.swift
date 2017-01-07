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
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = self.bounds
    }
    
    override func initModule() {
        NSLog("initModule")
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(ModuleView.buttonClicked), for: UIControlEvents.touchUpInside)
        button.setTitle("Pause", for: UIControlState())
        button.setTitle("Play", for: UIControlState.selected)
        self.addSubview(button)
        self.moduleDelegate?.view().addSubview(self)
        
    }
    
    func buttonClicked() {
        button.isSelected = !button.isSelected
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
    
    func endPlayCode(_ state: CPState) {
        NSLog("endPlayCode")
    }
    
    func willSection(_ cpu: CPURL) {
        NSLog("willSection")
    }
    
    func startSection(_ cpu: CPURL) {
        NSLog("startSection")
    }
    
    func endSection(_ cpu: CPURL) {
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
    
    func startSeek(_ time: TimeInterval) {
        NSLog("startSeek")
    }
    
    func seekTo(_ time: TimeInterval) {
        NSLog("seekTo")
    }
    
    func endSeek(_ time: TimeInterval, isEnd: Bool) {
        NSLog("endSeek")
    }
    
    func durationAvailable(_ duration: TimeInterval) {
        NSLog("durationAvailable")
    }
    
    func played(_ duration: TimeInterval) {
        NSLog("played")
    }
    
    func playable(_ duration: TimeInterval) {
        NSLog("playable")
    }
    
    func appResign() {
        NSLog("appResign")
    }
    
    func appActive() {
        NSLog("appActive")
    }
    
    func presentationSize(_ size: CGSize) {
        NSLog("presentationSize")
    }
    
    func airplayShift(_ on: Bool) {
        NSLog("airplayShift")
    }
    
    func interrupt(_ reason: InterruptionReason) {
        NSLog("interrupt")
    }
    
    func error(_ err: Int) {
        NSLog("error")
    }
}
