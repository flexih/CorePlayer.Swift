//
//  ProgressView.swift
//  CorePlayerDemo
//
//  Created by flexih on 11/16/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import UIKit

class ProgressView: UIView, ModuleViewDelegate {
    
    weak var moduleManager: ModuleManager?
    weak var moduleDelegate: CorePlayerFeature?
    
    var moduelIndex: Int = 0
    var moduleShow: Bool = false

    let lable = UILabel()

    func layoutView() {
        self.frame = CGRectMake(CGRectGetWidth(self.superview!.bounds) - 120, 0, 120, 50)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        lable.frame = self.bounds
    }

    func initModule() {
        self.backgroundColor = UIColor.blueColor()
        lable.textColor = UIColor.whiteColor()
        lable.backgroundColor = UIColor.clearColor()
        lable.font = UIFont.systemFontOfSize(12)
        lable.textAlignment = .Center
        self.addSubview(lable)
        self.moduleDelegate?.view().addSubview(self)

    }

    func durationStringFromSeconds(secs: NSTimeInterval) -> String {
        let hour = Int(secs) / 3600
        let min = Int(secs / 60) % 60
        let sec = Int(secs) % 60

        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, min, sec)
        } else {
            return String(format: "%02d:%02d", min, sec)
        }
    }

    func durationAvailable(duration: NSTimeInterval) {
        lable.text = durationStringFromSeconds(self.moduleDelegate!.played()) + "/" + durationStringFromSeconds(duration)
    }

    func played(duration: NSTimeInterval) {
        lable.text = durationStringFromSeconds(duration) + "/" + durationStringFromSeconds(self.moduleDelegate!.duration())
    }
}
