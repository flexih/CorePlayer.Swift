//
//  ProgressView.swift
//  CorePlayerDemo
//
//  Created by flexih on 11/16/15.
//  Copyright © 2015 flexih. All rights reserved.
//

import UIKit

class ProgressView: CPModuleView {

    let lable = UILabel()

    override func layoutView() {
        self.frame = CGRect(x: self.superview!.bounds.width - 120, y: 0, width: 120, height: 50)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        lable.frame = self.bounds
    }

    override func initModule() {
        self.backgroundColor = UIColor.blue
        lable.textColor = UIColor.white
        lable.backgroundColor = UIColor.clear
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .center
        self.addSubview(lable)
        self.moduleDelegate?.view().addSubview(self)

    }

    func durationStringFromSeconds(_ secs: TimeInterval) -> String {
        let hour = Int(secs) / 3600
        let min = Int(secs / 60) % 60
        let sec = Int(secs) % 60

        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, min, sec)
        } else {
            return String(format: "%02d:%02d", min, sec)
        }
    }

    func durationAvailable(_ duration: TimeInterval) {
        lable.text = durationStringFromSeconds(self.moduleDelegate!.played()) + "/" + durationStringFromSeconds(duration)
    }

    func played(_ duration: TimeInterval) {
        lable.text = durationStringFromSeconds(duration) + "/" + durationStringFromSeconds(self.moduleDelegate!.duration())
    }
}
